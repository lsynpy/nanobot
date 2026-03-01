"""DashScope provider - Alibaba Cloud Qwen models."""

from __future__ import annotations

from typing import Any

import json_repair
from openai import AsyncOpenAI

from pawpsicle.providers.base import LLMProvider, LLMResponse, ToolCallRequest


class DashScopeProvider(LLMProvider):
    """
    DashScope provider for Alibaba Cloud Qwen models.

    Uses OpenAI-compatible API endpoint.
    """

    def __init__(
        self,
        api_key: str,
        api_base: str = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        default_model: str = "qwen3.5-plus",
    ):
        super().__init__(api_key, api_base)
        self.default_model = default_model
        self._client = AsyncOpenAI(api_key=api_key, base_url=api_base)

    async def chat(
        self,
        messages: list[dict[str, Any]],
        tools: list[dict[str, Any]] | None = None,
        model: str | None = None,
        max_tokens: int = 4096,
        temperature: float = 0.7,
    ) -> LLMResponse:
        kwargs: dict[str, Any] = {
            "model": model or self.default_model,
            "messages": self._sanitize_empty_content(messages),
            "max_tokens": max(1, max_tokens),
            "temperature": temperature,
        }
        if tools:
            kwargs.update(tools=tools, tool_choice="auto")
        try:
            return self._parse(await self._client.chat.completions.create(**kwargs))
        except Exception as e:
            return LLMResponse(content=f"Error: {e}", finish_reason="error")

    def _parse(self, response: Any) -> LLMResponse:
        choice = response.choices[0]
        msg = choice.message
        tool_calls = []
        for tc in msg.tool_calls or []:
            args_raw = tc.function.arguments
            if isinstance(args_raw, str):
                parsed = json_repair.loads(args_raw)
                args: dict[str, Any] = parsed if isinstance(parsed, dict) else {}
            elif isinstance(args_raw, dict):
                args = args_raw
            else:
                args = {}
            tool_calls.append(ToolCallRequest(id=tc.id, name=tc.function.name, arguments=args))

        u = response.usage
        return LLMResponse(
            content=msg.content,
            tool_calls=tool_calls,
            finish_reason=choice.finish_reason or "stop",
            usage={
                "prompt_tokens": u.prompt_tokens,
                "completion_tokens": u.completion_tokens,
                "total_tokens": u.total_tokens,
            }
            if u
            else {},
            reasoning_content=getattr(msg, "reasoning_content", None) or None,
        )

    def get_default_model(self) -> str:
        return self.default_model
