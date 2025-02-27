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

# Ensure /root/.local/bin is in PATH
ENV PATH="/root/.local/bin:$PATH"

# Expose port if needed
EXPOSE 8080

# Set deployment configurations (No syncs, no connections)
ENV CONNECTION_NAME=disabled

# Source Configuration (Disabled)
ENV SOURCE_DOCKER_IMAGE=disabled
ENV SOURCE_CONFIG_COUNT=0
ENV SOURCE_CONFIG_SEED=0

# Destination Configuration (Disabled)
ENV DEST_DOCKER_IMAGE=disabled
ENV DEST_CONFIG_PROJECT_ID=disabled
ENV DEST_CONFIG_DATASET_ID=disabled
ENV DEST_CONFIG_CREDENTIALS_JSON="{}"

# Sync Configuration (Disabled)
ENV SYNC_FREQUENCY=disabled
ENV SYNC_NAMESPACE_FORMAT=disabled
ENV SYNC_STREAMS="[]"  # Empty list to prevent errors

# Remote Runner Configuration (Disabled)
ENV REMOTE_RUNNER_TYPE=disabled
ENV REMOTE_RUNNER_SERVICE_ACCOUNT=disabled

# Set runtime configurations (entrypoint)
ENV RUNTIME_ENTRYPOINT=run-env-vars

# Default Command for auto-run (No need to manually set entrypoint)
CMD ["abs", "run-env-vars"]
