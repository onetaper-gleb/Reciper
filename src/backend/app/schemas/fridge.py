from pydantic import BaseModel, Field


class RecognizedProductSchema(BaseModel):
    name: str
    amount: float | None = None
    unit: str | None = None
    confidence: float = Field(default=0.0, ge=0.0, le=1.0)


class FridgeScanResponse(BaseModel):
    recognized_products: list[RecognizedProductSchema] = Field(default_factory=list)
