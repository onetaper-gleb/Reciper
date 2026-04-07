import logging

from fastapi import APIRouter, Depends, HTTPException

from app.core.exceptions import AIServiceError, ValidationError
from app.schemas.meal_plan import (
    GeneratePlanRequest,
    GeneratePlanResponse,
    ReplaceMealRequest,
    ReplaceMealResponse,
)
from app.services.ai.gemini_client import GeminiTimeoutError
from app.services.meal_plan_service import MealPlanService


router = APIRouter(prefix="/meal-plans", tags=["meal-plans"])
logger = logging.getLogger(__name__)


def get_meal_plan_service() -> MealPlanService:
    return MealPlanService()


@router.post("/generate", response_model=GeneratePlanResponse)
def generate_meal_plan(
    request: GeneratePlanRequest,
    meal_plan_service: MealPlanService = Depends(get_meal_plan_service),
) -> GeneratePlanResponse:
    logger.info("POST /generate payload keys=%s", list(request.model_dump().keys()))
    try:
        return meal_plan_service.generate_plan(request)
    except GeminiTimeoutError as exc:
        raise HTTPException(status_code=504, detail=str(exc)) from exc
    except ValidationError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except AIServiceError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except Exception as exc:  # noqa: BLE001
        logger.exception("Unhandled error in /generate")
        raise HTTPException(status_code=500, detail=f"Unhandled server error: {exc}") from exc


@router.post("/replace-meal", response_model=ReplaceMealResponse)
def replace_meal(
    request: ReplaceMealRequest,
    meal_plan_service: MealPlanService = Depends(get_meal_plan_service),
) -> ReplaceMealResponse:
    logger.info("POST /replace-meal payload=%s", request.model_dump())
    try:
        return meal_plan_service.replace_meal(request)
    except GeminiTimeoutError as exc:
        raise HTTPException(status_code=504, detail=str(exc)) from exc
    except ValidationError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc
    except AIServiceError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc
    except Exception as exc:  # noqa: BLE001
        logger.exception("Unhandled error in /replace-meal")
        raise HTTPException(status_code=500, detail=f"Unhandled server error: {exc}") from exc

