# Use official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the entire project
COPY . /app

# Ensure the config.yaml file is copied to the correct location
COPY config.yaml /app/connections/config.yaml

# Install airbyte_serverless and dependencies
RUN pip install --no-cache-dir -e .

# Ensure /root/.local/bin is in PATH so abs CLI works
ENV PATH="/root/.local/bin:$PATH"

# Expose port if needed (depends on usage)
EXPOSE 8080

# **Fix: Set AIRBYTE_ENTRYPOINT to avoid missing variable error**
ENV AIRBYTE_ENTRYPOINT="run-env-vars"

# **Fix: Encode YAML_CONFIG at runtime instead of build time**
CMD ["sh", "-c", "export YAML_CONFIG_B64=$(base64 /app/connections/config.yaml | tr -d '\\n') && abs run-env-vars"]
