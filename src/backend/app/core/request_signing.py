import hmac
import secrets
import threading
import time
from dataclasses import dataclass
from hashlib import sha256

from fastapi import Request

from app.core.config import get_settings


class RequestSigningError(Exception):
    pass


@dataclass(frozen=True)
class SigningHeaders:
    timestamp: int
    nonce: str
    signature: str


def _parse_int(value: str | None, *, name: str) -> int:
    if value is None or not str(value).strip():
        raise RequestSigningError(f"Missing header: {name}")
    try:
        return int(str(value).strip())
    except ValueError as exc:  # noqa: PERF203
        raise RequestSigningError(f"Invalid header: {name}") from exc


def _parse_str(value: str | None, *, name: str) -> str:
    if value is None or not str(value).strip():
        raise RequestSigningError(f"Missing header: {name}")
    return str(value).strip()


def _canonical_path(request: Request) -> str:
    # FastAPI/Starlette: url.path excludes query params.
    return request.url.path


def _message(*, ts: int, nonce: str, method: str, path: str) -> bytes:
    # Keep canonicalization stable across client/server implementations.
    return f"{ts}\n{nonce}\n{method.upper()}\n{path}".encode("utf-8")


def compute_signature_hex(*, secret: str, ts: int, nonce: str, method: str, path: str) -> str:
    mac = hmac.new(secret.encode("utf-8"), _message(ts=ts, nonce=nonce, method=method, path=path), sha256)
    return mac.hexdigest()


def _now_epoch_seconds() -> int:
    return int(time.time())


class NonceReplayCache:
    """
    Simple in-memory replay cache with TTL.

    Note: This is best-effort. Since the backend is stateless (no Redis/DB),
    the cache resets on restart and doesn't coordinate across multiple instances.
    """

    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._nonces: dict[str, int] = {}
        self._last_cleanup_at = 0

    def check_and_store(self, nonce: str, *, ttl_seconds: int) -> None:
        now = _now_epoch_seconds()
        expires_at = now + ttl_seconds

        with self._lock:
            self._cleanup_if_needed(now)
            existing = self._nonces.get(nonce)
            if existing is not None and existing > now:
                raise RequestSigningError("Nonce already used")
            self._nonces[nonce] = expires_at

    def _cleanup_if_needed(self, now: int) -> None:
        # Cleanup at most once per ~30s to avoid per-request full scan.
        if now - self._last_cleanup_at < 30:
            return
        self._last_cleanup_at = now
        expired = [k for k, exp in self._nonces.items() if exp <= now]
        for k in expired:
            self._nonces.pop(k, None)


REPLAY_CACHE = NonceReplayCache()


def should_require_signing(request: Request) -> bool:
    settings = get_settings()
    if not settings.API_SIGNING_SECRET:
        return False

    # Skip CORS preflight
    if request.method.upper() == "OPTIONS":
        return False

    path = _canonical_path(request)
    # Allow health check unsigned (useful for infra probes)
    if path == "/api/v1/health":
        return False

    # Only protect our API surface
    return path.startswith("/api/v1/")


def validate_request_signature(request: Request) -> None:
    settings = get_settings()
    secret = settings.API_SIGNING_SECRET
    if not secret:
        return

    ts = _parse_int(request.headers.get("x-reciper-timestamp"), name="X-Reciper-Timestamp")
    nonce = _parse_str(request.headers.get("x-reciper-nonce"), name="X-Reciper-Nonce")
    sig = _parse_str(request.headers.get("x-reciper-signature"), name="X-Reciper-Signature")

    now = _now_epoch_seconds()
    max_skew = int(settings.API_SIGNING_MAX_SKEW_SECONDS or 120)
    if abs(now - ts) > max_skew:
        raise RequestSigningError("Timestamp outside allowed window")

    method = request.method
    path = _canonical_path(request)
    expected = compute_signature_hex(secret=secret, ts=ts, nonce=nonce, method=method, path=path)

    # Constant-time compare
    if not hmac.compare_digest(expected, sig.lower()):
        raise RequestSigningError("Invalid signature")

    # Best-effort anti-replay within the allowed time window
    REPLAY_CACHE.check_and_store(nonce, ttl_seconds=max_skew)


def generate_server_nonce() -> str:
    # Not used by current protocol, but kept handy.
    return secrets.token_urlsafe(18)

