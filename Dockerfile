FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip install --no-cache-dir -e .

ENV PATH="/root/.local/bin:$PATH"
EXPOSE 8080

ENV CONNECTION_NAME=disabled
ENV SOURCE_DOCKER_IMAGE=disabled
ENV SOURCE_CONFIG_COUNT=0
ENV SOURCE_CONFIG_SEED=0
ENV DEST_DOCKER_IMAGE=disabled
ENV DEST_CONFIG_PROJECT_ID=disabled
ENV DEST_CONFIG_DATASET_ID=disabled
ENV DEST_CONFIG_CREDENTIALS_JSON="{}"
ENV SYNC_FREQUENCY=disabled
ENV SYNC_NAMESPACE_FORMAT=disabled
ENV SYNC_STREAMS="[]"
ENV REMOTE_RUNNER_TYPE=disabled
ENV REMOTE_RUNNER_SERVICE_ACCOUNT=disabled
ENV YAML_CONFIG_B64="eyJ9Cg=="
RUN touch /app/empty_config.yaml
ENV YAML_CONFIG="/app/empty_config.yaml"
ENV AIRBYTE_ENTRYPOINT="run-env-vars"

CMD ["abs", "run-env-vars"]
