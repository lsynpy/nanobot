.PHONY: install dev test lint format clean skill

install:
	uv pip install -e .

dev:
	uv pip install -e ".[dev]"

test:
	pytest

lint:
	ruff check .
	rumdl check .
	ty check pawpsicle tests

format:
	ruff format .
	rumdl fmt

clean:
	rm -rf __pycache__ .pytest_cache .ruff_cache
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

skill:
	python scripts/create_skill.py $(word 2,$(MAKECMDGOALS))

%:
	@:
