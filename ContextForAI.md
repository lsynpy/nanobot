# nanobot Project Context

## Project Overview

**nanobot** is an ultra-lightweight personal AI assistant framework written in Python. It delivers core agent functionality in approximately **4,000 lines of code** (99% smaller than comparable projects like Clawdbot's 430k+ lines).

### Key Characteristics

- **Ultra-Lightweight**: ~4,000 lines of core agent code
- **Multi-Channel**: Supports Telegram, Discord, WhatsApp, Feishu, Slack, Email, QQ, DingTalk, Matrix, and Mochat
- **Multi-Provider**: Supports 15+ LLM providers including OpenRouter, Anthropic, OpenAI, DeepSeek, Groq, Gemini, and local vLLM
- **Research-Friendly**: Clean, readable code designed for easy understanding and extension
- **Skill System**: Extensible skills architecture for adding custom capabilities
- **MCP Support**: Model Context Protocol integration for tool extensibility

### Architecture Components

```
nanobot/
├── agent/          # Core AI agent logic, memory, tools, subagents
├── bus/            # Event bus (InboundMessage, OutboundMessage)
├── channels/       # Chat platform integrations (Telegram, Discord, etc.)
├── cli/            # Command-line interface (typer-based)
├── config/         # Configuration schema and management
├── cron/           # Scheduled task support
├── heartbeat/      # Agent heartbeat mechanism
├── providers/      # LLM provider registry and implementations
├── session/        # Session management
├── skills/         # Built-in skills (github, weather, summarize, tmux, etc.)
├── templates/      # Agent prompt templates
└── utils/          # Utility functions
```

## Building and Running

### Installation

**From source (development):**

```bash
git clone https://github.com/HKUDS/nanobot.git
cd nanobot
pip install -e .
```

**With uv (recommended):**

```bash
uv tool install nanobot-ai
```

**From PyPI:**

```bash
pip install nanobot-ai
```

### Development Dependencies

```bash
pip install -e ".[dev]"
# or
uv pip install -e ".[dev]"
```

### Running Commands

**CLI Commands:**

```bash
nanobot --help           # Show all commands
nanobot onboard          # Initialize configuration
nanobot agent            # Start interactive agent chat
nanobot gateway          # Start chat channel gateway
nanobot status           # Show system status
nanobot provider login   # OAuth login for providers
```

**Testing:**

```bash
pytest
# or
pytest tests/
```

**Code Formatting:**

```bash
ruff check .
ruff format .
```

**Docker:**

```bash
docker-compose up nanobot-gateway
docker-compose run nanobot-cli agent
```

### Configuration

Config file location: `~/.nanobot/config.json`

**Basic setup:**

```json
{
  "providers": {
    "openrouter": {
      "apiKey": "sk-or-v1-xxx"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-opus-4-5",
      "provider": "openrouter"
    }
  }
}
```

## Development Conventions

### Code Style

- **Formatter**: ruff (line-length: 100, target: Python 3.11+)
- **Linting**: ruff with E, F, I, N, W rules (E501 ignored)
- **Type Hints**: Uses Python type hints throughout
- **Imports**: Sorted automatically by ruff (I rule)

### Project Structure

- **Python Version**: 3.11+
- **Package Manager**: Supports pip, uv, and hatchling build system
- **Dependencies**: Managed in `pyproject.toml`
- **Optional Dependencies**: `matrix` for Matrix support, `dev` for development

### Testing Practices

- **Framework**: pytest with pytest-asyncio
- **Test Location**: `tests/` directory
- **Async Mode**: Auto mode for asyncio tests

### Git Conventions

- Commit messages should be concise and focused
- Sign off commits with signature (e.g., `<msg>. - QwenCode`)
- Review changes before committing

### Adding New Components

**New Provider (2 steps):**

1. Add `ProviderSpec` entry to `nanobot/providers/registry.py`
2. Add field to `ProvidersConfig` in `nanobot/config/schema.py`

**New Channel:**

- Create `nanobot/channels/<channel>.py`
- Implement channel-specific logic following existing patterns

**New Skill:**

- Create directory under `nanobot/skills/<skill-name>/`
- Include `SKILL.md` with YAML frontmatter and instructions

## Key Technologies

| Technology | Purpose |
|------------|---------|
| **typer** | CLI framework |
| **litellm** | LLM provider abstraction |
| **pydantic** | Data validation and settings |
| **websockets** | WebSocket connections |
| **httpx** | Async HTTP client |
| **loguru** | Logging |
| **rich** | Terminal formatting |
| **prompt-toolkit** | Interactive CLI |
| **mcp** | Model Context Protocol |
| **croniter** | Scheduled tasks |

## Core Concepts

### Event Bus

Uses a simple event bus pattern with `InboundMessage` and `OutboundMessage` dataclasses for channel communication.

### Session Management

Sessions are keyed by `channel:chat_id` for multi-user support with thread isolation.

### Agent Loop

The agent runs a continuous loop handling:

1. Message reception via channels
2. Context building and memory retrieval
3. LLM invocation with tool calling
4. Response generation and delivery

### Tools

Built-in tools include: web search, file system operations, shell commands, cron scheduling, MCP tools, and message handling.

### Memory

Redesigned memory system for efficient context management across conversations.

## Line Count Verification

Run `bash core_agent_lines.sh` to verify the core agent line count (excludes channels/, cli/, providers/ adapters).

## Version

Current version: **0.1.4.post2**

## Qwen Added Memories

- Project comment style: Code should be self-explanatory without verbose comments. Remove simple docstrings that just restate what code does (e.g., """Get the default configuration file path."""). Keep design notes, implementation details, implementation decisions, and tricky things (e.g., class-level architecture docs explaining what the component does and why).
- Git commit messages should be one-line and shortened when possible, with signature (e.g., `<msg>. - QwenCode`)
