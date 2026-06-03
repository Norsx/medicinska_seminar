FROM mcr.microsoft.com/devcontainers/python:3.11

# Install Tectonic (Rust-based LaTeX engine, ~50MB vs ~500MB for texlive)
RUN curl --proto '=https' --tlsv1.2 -fsSL https://drop-sh.fullyjustified.net | sh \
    && mv /root/.cargo/bin/tectonic /usr/local/bin/ \
    && rm -rf /root/.cargo

# Install uv (fast Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/ \
    && mv /root/.local/bin/uvx /usr/local/bin/ 2>/dev/null || true

# Manim and multimedia dependencies (optional, for fsb-video template)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        ffmpeg \
        libcairo2-dev \
        libpango1.0-dev \
        pkg-config \
        build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
