"""LLM provider abstraction module."""

from pawpsicle.providers.base import LLMProvider, LLMResponse
from pawpsicle.providers.custom_provider import DashScopeProvider

__all__ = ["LLMProvider", "LLMResponse", "DashScopeProvider"]
