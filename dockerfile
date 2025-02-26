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
RUN pip install --no-cache-dir .

# Expose port if required (depends on usage)
EXPOSE 8080

# Default command to run the CLI
ENTRYPOINT ["abs"]
