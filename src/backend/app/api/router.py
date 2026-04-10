from fastapi import APIRouter

from app.core.constants import API_PREFIX
from app.api.v1.router import router as v1_router


router = APIRouter(prefix=API_PREFIX)
router.include_router(v1_router)

