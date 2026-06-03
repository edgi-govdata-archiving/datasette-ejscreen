FROM python:3.13

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Create datasette user
RUN useradd -m -u 1000 datasette && \
    chown -R datasette:datasette /app

# Copy requirements
COPY plugins.txt .

# Install Datasette and plugins
RUN pip install --no-cache-dir datasette && \
    if [ -s plugins.txt ]; then \
        pip install --no-cache-dir -r plugins.txt; \
    fi

# Create data directory
RUN mkdir -p /app/data && \
    chown -R datasette:datasette /app/data

# Copy database files and metadata
COPY --chown=datasette:datasette data/ /app/data/
COPY --chown=datasette:datasette metadata.json /app/

# Switch to datasette user
USER datasette

# Expose port
EXPOSE 8001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8001/-/health').read()" || exit 1

# Start Datasette
CMD ["datasette", "serve", \
     "/app/data/*.db", \
     "--host", "0.0.0.0", \
     "--port", "8001", \
     "--metadata", "/app/metadata.json", \
     "--cors", \
     "--setting", "sql_time_limit_ms", "5000", \
     "--setting", "max_returned_rows", "1000"]
