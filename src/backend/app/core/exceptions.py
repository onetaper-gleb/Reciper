from fastapi import Request
from fastapi.responses import JSONResponse


class AIServiceError(Exception):
    def __init__(self, message: str) -> None:
        self.message = message
        super().__init__(message)


class ValidationError(Exception):
    def __init__(self, message: str) -> None:
        self.message = message
        super().__init__(message)


async def ai_service_exception_handler(
    request: Request, exc: AIServiceError  # noqa: ARG001
) -> JSONResponse:
    return JSONResponse(status_code=502, content={"detail": exc.message})


async def validation_exception_handler(
    request: Request, exc: ValidationError  # noqa: ARG001
) -> JSONResponse:
    return JSONResponse(status_code=422, content={"detail": exc.message})

