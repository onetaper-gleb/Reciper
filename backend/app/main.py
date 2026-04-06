from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.router import router as api_router
from app.core.config import get_settings
from app.core.exceptions import (
    AIServiceError,
    ValidationError,
    ai_service_exception_handler,
    validation_exception_handler,
)
from app.core.logging import configure_logging


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

    app.add_exception_handler(AIServiceError, ai_service_exception_handler)
    app.add_exception_handler(ValidationError, validation_exception_handler)

    return app


app = create_app()

