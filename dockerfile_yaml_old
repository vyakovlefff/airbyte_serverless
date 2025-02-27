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

# **Fix: Set YAML_CONFIG to the correct full path**
ENV YAML_CONFIG="/app/connections/config.yaml"

# Install airbyte_serverless and dependencies
RUN pip install --no-cache-dir -e .

# Ensure /root/.local/bin is in PATH so abs CLI works
ENV PATH="/root/.local/bin:$PATH"

# Expose port if needed (depends on usage)
EXPOSE 8080

# **Fix: Set AIRBYTE_ENTRYPOINT to avoid missing variable error**
ENV AIRBYTE_ENTRYPOINT="run-env-vars"

# **Hardcode Base64 String (Replace with the real one)**
ENV YAML_CONFIG_B64="IyBEZWZpbmUgdGhlIEFpcmJ5dGUgY29ubmVjdGlvbiBuYW1lCmNvbm5lY3Rpb25fbmFtZTogImFpcmJ5dGVfc2VydmVybGVzc19jb25uZWN0aW9uIgoKIyBEZWZpbmUgdGhlIHNvdXJjZSBjb25uZWN0b3IgKEV4YW1wbGU6IEZha2UgRGF0YSBHZW5lcmF0b3IpCnNvdXJjZToKICBkb2NrZXJfaW1hZ2U6ICJhaXJieXRlL3NvdXJjZS1mYWtlcjpsYXRlc3QiCiAgY29uZmlnOgogICAgY291bnQ6IDEwMCAgIyBOdW1iZXIgb2YgcmVjb3JkcyB0byBnZW5lcmF0ZQogICAgc2VlZDogNDIgICAgIyBTZWVkIGZvciByZXByb2R1Y2liaWxpdHkKCiMgRGVmaW5lIHRoZSBkZXN0aW5hdGlvbiBjb25uZWN0b3IgKEV4YW1wbGU6IEdvb2dsZSBCaWdRdWVyeSkKZGVzdGluYXRpb246CiAgZG9ja2VyX2ltYWdlOiAiYWlyYnl0ZS9kZXN0aW5hdGlvbi1iaWdxdWVyeTpsYXRlc3QiCiAgY29uZmlnOgogICAgcHJvamVjdF9pZDogIm15LWdjcC1wcm9qZWN0IgogICAgZGF0YXNldF9pZDogImFpcmJ5dGVfZGF0YXNldCIKICAgIGNyZWRlbnRpYWxzX2pzb246IEdDUF9TRUNSRVQoInByb2plY3RzL215LWdjcC1wcm9qZWN0L3NlY3JldHMvYmlncXVlcnkta2V5L3ZlcnNpb25zL2xhdGVzdCIpICAjIFVzZXMgR29vZ2xlIFNlY3JldCBNYW5hZ2VyIGZvciBzZWN1cml0eQoKIyBEZWZpbmUgdGhlIHN5bmMgc2V0dGluZ3MKc3luYzoKICBmcmVxdWVuY3k6ICJtYW51YWwiICAjIENhbiBhbHNvIGJlIGEgY3JvbiBleHByZXNzaW9uCiAgbmFtZXNwYWNlX2Zvcm1hdDogIm15X2FpcmJ5dGVfbmFtZXNwYWNlIgogIHN0cmVhbXM6CiAgICAtIG5hbWU6ICJ1c2VycyIKICAgICAgc3luY19tb2RlOiAiZnVsbF9yZWZyZXNoIgogICAgICBkZXN0aW5hdGlvbl9zeW5jX21vZGU6ICJhcHBlbmQiCiAgICAgIHByaW1hcnlfa2V5OiBbImlkIl0KICAgICAgY3Vyc29yX2ZpZWxkOiBbInVwZGF0ZWRfYXQiXQoKIyBSZW1vdGUgcnVubmVyIGZvciBDbG91ZCBSdW4KcmVtb3RlX3J1bm5lcjoKICB0eXBlOiAiY2xvdWRfcnVuX2pvYiIKICBzZXJ2aWNlX2FjY291bnQ6ICJ5b3VyLXNlcnZpY2UtYWNjb3VudEB5b3VyLXByb2plY3QuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCgojIEV4dHJhIGNvbmZpZ3VyYXRpb24gdG8gYXZvaWQgbWlzc2luZyB2YXJpYWJsZSBlcnJvcnMKcnVudGltZToKICBlbnRyeXBvaW50OiAicnVuLWVudi12YXJzIgogIHlhbWxfY29uZmlnOiAiL2FwcC9jb25uZWN0aW9ucy9jb25maWcueWFtbCIK"

# **Run abs with the manually set YAML_CONFIG_B64**
ENTRYPOINT ["/bin/sh", "-c", "exec abs run-env-vars"]
