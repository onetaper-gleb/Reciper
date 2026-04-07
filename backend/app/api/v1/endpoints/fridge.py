from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile

from app.core.exceptions import AIServiceError, ValidationError
from app.schemas.fridge import FridgeScanResponse
from app.services.ai.gemini_client import GeminiTimeoutError
from app.services.fridge_scan_service import FridgeScanService
from app.utils.image_utils import prepare_image_for_gemini

router = APIRouter(prefix="/fridge", tags=["fridge"])


def get_fridge_scan_service() -> FridgeScanService:
    return FridgeScanService()


@router.post("/scan", response_model=FridgeScanResponse)
async def scan_fridge(
    image: UploadFile = File(...),
    existing_products_json: str | None = Form(default=None),
    scan_mode: str = Form(default="replace"),
    fridge_scan_service: FridgeScanService = Depends(get_fridge_scan_service),
) -> FridgeScanResponse:
    try:
        image_bytes = await image.read()
        prepared_image = prepare_image_for_gemini(image_bytes)
        return fridge_scan_service.scan_fridge(prepared_image, existing_products_json, scan_mode)
    except GeminiTimeoutError as exc:
        raise HTTPException(status_code=504, detail=str(exc)) from exc
    except ValidationError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except AIServiceError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc
