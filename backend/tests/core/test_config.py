from pathlib import Path
import sys

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.core.config import Settings  # noqa: E402


def test_settings_reads_env(monkeypatch) -> None:
    monkeypatch.setenv("GEMINI_MODEL", "test-model")
    monkeypatch.setenv("LOG_LEVEL", "DEBUG")
    monkeypatch.setenv("CORS_ORIGINS", "http://localhost:3000,http://localhost:5173")

    settings = Settings()

    assert settings.GEMINI_MODEL == "test-model"
    assert settings.LOG_LEVEL == "DEBUG"
    assert settings.CORS_ORIGINS == ["http://localhost:3000", "http://localhost:5173"]

