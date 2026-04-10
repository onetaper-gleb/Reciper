import logging
from pathlib import Path
from typing import Any

logger = logging.getLogger(__name__)


class _SafeFormatDict(dict):
    def __missing__(self, key: str) -> str:
        return "{" + key + "}"


class PromptLoader:
    def __init__(self, prompts_root: Path | None = None) -> None:
        if prompts_root is None:
            prompts_root = Path(__file__).resolve().parents[3] / "prompts"
        self.prompts_root = prompts_root
        logger.info("PromptLoader initialized, prompts_root=%s", self.prompts_root)

    def load(self, relative_path: str, **kwargs: Any) -> str:
        prompt_path = self.prompts_root / relative_path
        if not prompt_path.exists():
            raise FileNotFoundError(f"Prompt template not found: {prompt_path}")

        template = prompt_path.read_text(encoding="utf-8")
        if not kwargs:
            return template
        return template.format_map(_SafeFormatDict(kwargs))

