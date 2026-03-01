"""Message bus module for decoupled channel-agent communication."""

from pawpsicle.bus.events import InboundMessage, OutboundMessage
from pawpsicle.bus.queue import MessageBus

__all__ = ["MessageBus", "InboundMessage", "OutboundMessage"]
