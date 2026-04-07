from app.core.exceptions import ValidationError


def prepare_image_for_gemini(
    image_bytes: bytes,
    *,
    max_size_bytes: int = 4 * 1024 * 1024,
) -> bytes:
    """
    Lightweight image preprocessing for Gemini requests.
    - Reject empty images.
    - Enforce an upper payload limit to keep requests stable.
    """
    if not image_bytes:
        raise ValidationError("Image file is empty")
    if len(image_bytes) > max_size_bytes:
        raise ValidationError(f"Image is too large (>{max_size_bytes} bytes)")
    return image_bytes
