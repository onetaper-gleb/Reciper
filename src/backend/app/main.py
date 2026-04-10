from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.router import router as api_router
from app.core.config import get_settings
from app.core.exceptions import (
    AIServiceError,
    ValidationError,
    ai_service_exception_handler,
    validation_exception_handler,
)
from app.core.logging import configure_logging
from app.core.request_signing import (
    RequestSigningError,
    should_require_signing,
    validate_request_signature,
)


def create_app() -> FastAPI:
    configure_logging()
    settings = get_settings()

    app = FastAPI(title="Reciper Backend", version="0.1.0")

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS or ["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(api_router)

    @app.middleware("http")
    async def request_signing_middleware(request, call_next):  # type: ignore[no-untyped-def]
        if should_require_signing(request):
            try:
                validate_request_signature(request)
            except RequestSigningError as exc:
                return JSONResponse(status_code=401, content={"detail": str(exc)})

        return await call_next(request)

    app.add_exception_handler(AIServiceError, ai_service_exception_handler)
    app.add_exception_handler(ValidationError, validation_exception_handler)

    return app


app = create_app()

