from pathlib import Path
import sys

from fastapi.testclient import TestClient

PROJECT_ROOT = Path(__file__).resolve().parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from app.api.v1.endpoints.fridge import get_fridge_scan_service  # noqa: E402
from app.main import app  # noqa: E402


class FakeFridgeScanService:
    def scan_fridge(self, image_bytes: bytes, existing_products_json: str | None, scan_mode: str):  # noqa: ANN001
        assert image_bytes
        assert scan_mode in {"replace", "append"}
        if existing_products_json:
            return {
                "recognized_products": [
                    {"name": "Milk", "amount": 1, "unit": "l", "confidence": 0.95},
                    {"name": "Eggs", "amount": 6, "unit": "pcs", "confidence": 0.91},
                ]
            }
        return {"recognized_products": [{"name": "Milk", "amount": 1, "unit": "l", "confidence": 0.95}]}


client = TestClient(app)


def test_fridge_scan_returns_200_and_products() -> None:
    app.dependency_overrides[get_fridge_scan_service] = lambda: FakeFridgeScanService()
    response = client.post(
        "/api/v1/fridge/scan",
        files={"image": ("fridge.jpg", b"fake-image-bytes", "image/jpeg")},
        data={"scan_mode": "replace"},
    )
    app.dependency_overrides.clear()

    assert response.status_code == 200
    body = response.json()
    assert body["recognized_products"][0]["name"] == "Milk"
    assert body["recognized_products"][0]["confidence"] == 0.95


def test_fridge_scan_append_accepts_existing_products() -> None:
    app.dependency_overrides[get_fridge_scan_service] = lambda: FakeFridgeScanService()
    response = client.post(
        "/api/v1/fridge/scan",
        files={"image": ("fridge.jpg", b"fake-image-bytes", "image/jpeg")},
        data={
            "scan_mode": "append",
            "existing_products_json": '[{"name":"Eggs","amount":4,"unit":"pcs","confidence":0.9}]',
        },
    )
    app.dependency_overrides.clear()

    assert response.status_code == 200
    assert len(response.json()["recognized_products"]) == 2
