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

# Set required environment variables
ENV AIRBYTE_SOURCE=airbyte-source-faker
ENV AIRBYTE_DESTINATION=airbyte-destination-bigquery
ENV CONFIG_PATH=/app/connections/config.yaml
ENV AIRBYTE_ENTRYPOINT="run-env-vars"  # Fix missing environment variable

# Copy configuration file into the container (if using a config-based setup)
COPY ./connections/config.yaml /app/connections/config.yaml

# Default command to run Airbyte Serverless
ENTRYPOINT ["abs", "run-env-vars"]
