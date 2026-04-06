from fastapi import APIRouter

from app.core.constants import API_V1_PREFIX
from app.api.v1.endpoints.health import router as health_router
from app.api.v1.endpoints.meal_plans import router as meal_plans_router


router = APIRouter(prefix=API_V1_PREFIX)
router.include_router(health_router)
router.include_router(meal_plans_router)

