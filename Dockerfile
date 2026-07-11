FROM python:3.13.3-slim

WORKDIR /app

# Install uv
RUN pip install --no-cache-dir uv

COPY . .

# uv'nin sanal ortamını /opt içine oluştur
ENV UV_PROJECT_ENVIRONMENT=/opt/venv

# Install project
RUN uv sync

ENV PYTHONPATH=/app/src
ENV PYTHONUNBUFFERED=1

RUN groupadd --gid 1000 mcp && \
    useradd --uid 1000 --gid 1000 --create-home mcp && \
    mkdir -p /opt/venv && \
    chown -R mcp:mcp /app /opt/venv

USER mcp

# Used only when MCP_TRANSPORT=sse or streamable-http; stdio needs no port.
EXPOSE 8000

ENTRYPOINT ["uv", "run", "./entrypoint.py"]
