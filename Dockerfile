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

# Install airbyte_serverless and dependencies
RUN pip install --no-cache-dir -e .

# Ensure /root/.local/bin is in PATH so abs CLI works
ENV PATH="/root/.local/bin:$PATH"

# Expose port if needed (depends on usage)
EXPOSE 8080

# **Fix: Set AIRBYTE_ENTRYPOINT to avoid missing variable error**
ENV AIRBYTE_ENTRYPOINT="run-env-vars"

# **Fix: Encode YAML_CONFIG in Base64 (this prevents the Incorrect Padding error)**
RUN cat /app/connections/config.yaml | base64 -w 0 > /app/connections/config.yaml.b64
ENV YAML_CONFIG_B64="$(cat /app/connections/config.yaml.b64)"

# Default command to run Airbyte Serverless
ENTRYPOINT ["abs", "run-env-vars"]
