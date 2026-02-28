FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install git and pre-commit tools for AI agent development
COPY requirements.txt ./
COPY pyproject.toml README.md LICENSE ./

RUN apt-get update && \
    apt-get install -y --no-install-recommends git curl && \
    rm -rf /var/lib/apt/lists/* && \
    # Install pre-commit and pre-commit-hooks for AI agent code editing
    pip install --no-cache-dir pre-commit pre-commit-hooks && \
    # Install typos (spell checker) and rumdl (markdown linter) - both Rust-based
    curl -sS https://webinstall.dev/typos | bash && \
    mv /root/.local/bin/typos /usr/local/bin/typos && \
    curl -LO https://github.com/rvben/rumdl/releases/latest/download/rumdl-linux-x86_64.tar.gz && \
    tar xzf rumdl-linux-x86_64.tar.gz && \
    mv rumdl /usr/local/bin/ && \
    rm rumdl-linux-x86_64.tar.gz && \
    # Clean up
    apt-get clean && rm -rf /var/cache/apt/*

# Install Python dependencies (cached layer)
RUN uv pip install --system --no-cache -r requirements.txt && \
    rm -f requirements.txt

# Copy source and install nanobot
COPY nanobot/ nanobot/
RUN uv pip install --system --no-cache .

# Create config directory and initialize pre-commit for AI agent
RUN mkdir -p /root/.nanobot && \
    git config --global --add safe.directory /app && \
    pre-commit install

# Gateway default port
EXPOSE 18790

ENTRYPOINT ["nanobot"]
CMD ["status"]
