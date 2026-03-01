# Pawpsicle Project Context

## Project Overview

**pawpsicle** is an ultra-lightweight personal AI assistant framework written in Python.

### Key Characteristics

- **Single Channel**: Feishu
- **Single Provider**: AliyunCS
- **Minimal Dependency**: Ultra-lightweight with minimal external dependencies
- **Small Footprint**: Designed to run on embedded devices with limited resources

### Architecture Components

```text
pawpsicle/
├── agent/          # Core AI agent logic, memory, tools, subagents
├── bus/            # Event bus (InboundMessage, OutboundMessage)
├── channels/       # Chat platform integrations (Feishu)
├── cli/            # Command-line interface (typer-based)
├── config/         # Configuration schema and management
├── cron/           # Scheduled task support
├── heartbeat/      # Agent heartbeat mechanism
├── providers/      # LLM provider registry and implementations (AliyunCS)
├── session/        # Session management
├── templates/      # Agent prompt templates
└── utils/          # Utility functions
```

## Building and Running

### Installation

 [onboard skill](.agents/skills/pawpsicle-onboard/SKILL.md)

## Development

 [develop skill](.agents/skills/pawpsicle-develop/SKILL.md)

### Code Style

- **Formatter**: ruff (line-length: 100, target: Python 3.11+)
- **Linting**: ruff with E, F, I, N, W rules (E501 ignored)
- **Type Checker**: ty (10-60x faster than mypy/pyright)
- **Type Hints**: Uses Python type hints throughout
- **Imports**: Sorted automatically by ruff (I rule)
- **Type Config**: `ty.toml` for rule customization

### Make Commands

- `make install` - Install package in development mode
- `make dev` - Install development dependencies
- `make test` - Run tests with pytest
- `make format` - Format code with ruff and rumdl
- `make lint` - Lint code with ruff
- `make typecheck` - Type check with ty
- `make clean` - Clean cache files

### Skills

- [test skill](.agents/skills/pawpsicle-test/SKILL.md)
- [debug skill](.agents/skills/pawpsicle-debug/SKILL.md)

### Rules

- Commit messages: concise, one-line, shortened when possible
- Sign off: `<msg>. - QwenCode` (AI agent signature)
- Review changes before committing
- Comments: code should be self-explanatory
  - Remove docstrings that just restate code (e.g., `"""Get the config path."""`)
  - Keep design notes, implementation details, decisions, and tricky logic
