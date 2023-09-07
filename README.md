
![logo](https://github.com/unytics/airbyte_serverless/assets/111615732/c922cc30-9391-4d42-8aff-8b2b4c68bd29)


<p align="center">
    <em>Airbyte made simple</em>
</p>

---

## Why `airbyte_serverless` ?

> At [Unytics](https://www.linkedin.com/company/unytics/), we ❤️ [Airbyte](https://airbyte.com/) which provides a **catalog of open-source connectors to move your data from any source to your data-warehouse.**
>
> **Airbyte Open-Source Platform is "batteries included"** 🔋.<br>You'll get a server, workers, database, UI, orchestrator, connectors, secret manager, logs manager, etc. All of this is very well packaged and deployable on Kubernetes.
> While we believe this is great for most people we strive for lightweight and simple assets to deploy and maintain.
>
> **👉 We wanted a simple tool to manage Airbyte connectors, run them locally or deploy them in *serverless* mode. 👈**

<br>

| Airbyte Open-Source Platform    | Airbyte Serverless |
| -------- | ------- |
| **Has a UI** | **Has NO UI**<br>Connections configurations are generated as documented-yaml-files that can be edited and versioned with git |
| **Has a database**  | **Has NO database**<br>- Connectors Configurations are stored in files versioned in git<br>- The destination stores the `state` (the [checkpoint](https://airbyte.com/blog/checkpointing) of where sync stops)<br>- The destination stores the `logs` which can then be visualized with your preferred BI tool |
| **Has a transform layer**<br>Airbyte loads your data in a raw format but then enables you to perform basic transform such as replace, upsert, [schema normalization](https://docs.airbyte.com/understanding-airbyte/basic-normalization/)   | **Has NO transform layer**<br>Data is appended in your destination in raw format. `airbyte_serverless` is dedicated to do one thing and do it well: `Extract-Load`. |
| **Deployed on a VM or Kubernetes Cluster**  | **Deployed with Serverless**<br>- An Airbyte source docker image is upgraded with a destination connector from `airbyte_serverless`<br>- The upgraded docker image can then be deployed as an isolated `Cloud Run Job` (or `Cloud Run Service`)<br>- Cloud Run is natively monitored with metrics, dashboards, logs, error reporting, alerting, etc<br>- They can be scheduled or triggred upon cloud events  |
| **Is scalable with conditions**<br>Scalable if deployed on autoscaled Kubernetes Cluster and if you are skilled enough.<br>👉 **Check that you are skilled enough with Kubernetes by watching [this video](https://www.youtube.com/watch?v=9wvEwPLcLcA)** 😁. | **Is scalable**<br>Each connector is deployed independently of each other. You can have as many as you want. |




## Features

> 1. ⚡ A lightweight python wrapper around any Airbyte Source executable.
> 2. ⚡ Destination Connectors (only BigQuery for now - *contibutions are welcome* 🤗) which store `logs` and `states` in addition to data. Thus, there is **no need for a database any more!**
> 3. ⚡ Examples to deploy to **serverless** compute (only Google Cloud Run for now - *contibutions are welcome* 🤗)



## Getting Started

#### 1. Install

```bash
pip install airbyte-serverless
```

#### 2. Create an Airbyte Source from a public docker image

> ⚠️ For this to work you need to have docker in your machine

Write the following code in a file `getting_started.py` (change `surveymonkey` with the source you want). Then, you can run it with `python getting_started.py`. *If it does not work, please raise an issue.* You can list public airbyte source docker images [here](https://hub.docker.com/search?q=airbyte%2Fsource-)


```python
from airbyte_serverless.sources import DockerAirbyteSource

docker_image = 'airbyte/source-surveymonkey:latest'
source = AirbyteSource(docker_image)
```

<details>
  <summary><u>If you don't have docker <i>(or don't want to use it)</i></u></summary>

>  It is also possible to clone airbyte repo and install a python source connector:
>
>  1. Clone the repo
>  2. Go to the directory of the connector: `cd airbyte-integrations/connectors/source-surveymonkey`
>  3. Install the python connector `pip install -r requirements.txt`
>  4. Create here a file `getting_started.py` but with the following content:
>
>  ```python
> from airbyte_serverless.sources import AirbyteSource
>
> airbyte_source_executable = 'python main.py'
> source = AirbyteSource(airbyte_source_executable)
>  ```
</details>


#### 3. Update `config` for your Airbyte Source

Your Airbyte Source needs some config to be able to connect. Show a pre-filled `config` for your connector with:

```python
print(source.config)
```

Copy the content, edit it and update the variable:

```python
source.config = '''
YOUR UPDATED CONFIG
'''
```


#### 4. Check your `config`

```python
print(source.connection_status)
```


#### 5. Update `configured_catalog` for your Airbyte Source

The source `catalog` lists the available `streams` (think entities) that the source is able to retrieve. The `configured_catalog` specifies which `streams` to extract and how. Show the default `configured_catalog` with:

```python
print(source.configured_catalog)
```

If needed, copy the content, edit it and update the variable:

```python
source.configured_catalog = {
   ...YOUR UPDATED CONFIG
}
```


#### 6. Test the retrieval of one data record

```python
print(source.first_record)
```

#### 7. Create a destination and run Extract-Load

```python
from airbyte_serverless.destinations import BigQueryDestination

destination = BigQueryDestination(dataset='YOUR-PROJECT.YOUR_DATASET')
data = source.extract()
destination.load(data)
```


#### 8. Run Extract-Load from where you stopped

The `state` keeps track from where the latest extract-load ended (for incremental extract-load).
To start from this `state` run:

```python
state = destination.get_state()
data = source.extract(state=state)
destination.load(data)
```


## End to End Example

```python

from airbyte_serverless.sources import DockerAirbyteSource
from airbyte_serverless.destinations import BigQueryDestination

docker_image = 'airbyte/source-surveymonkey:latest'
config = 'YOUR CONFIG'
configured_catalog = {YOUR CONFIGURED CATALOG}
source = DockerAirbyteSource(docker_image, config=config, configured_catalog=configured_catalog)

destination = BigQueryDestination(dataset='YOUR-PROJECT.YOUR_DATASET')

state = destination.get_state()
data = source.extract(state=state)
destination.load(data)
```




## Deploy

To deploy to Cloud Run job, edit Dockerfile to pick the Airbyte source you like then run:



## Limitations

- BigQuery Destination connector only works in append mode
- Data at destination is in raw format. No data parsing is done.

We believe, [like Airbyte](https://docs.airbyte.com/understanding-airbyte/basic-normalization), that it is a good thing to decouple data moving and data transformation. To shape your data you may want to use a tool such as dbt. Thus, we follow the EL-T philosophy.


## Credits

The generation of the sample connector configuration in yaml is heavily inspired from the code of `octavia` CLI developed by airbyte.


## Contribute

Any contribution is more than welcome 🤗!
- Add a ⭐ on the repo to show your support
- Raise an issue to raise a bug or suggest improvements
- Open a PR! Below are some suggestions of work to be done:
  - improve secrets management
  - implement a CLI
  - manage configurations as yaml files
  - implement the `get_logs` method of `BigQueryDestination`
  - add a new destination connector (Cloud Storage?)
  - add more serverless deployment examples.
  - implement optional post-processing (replace, upsert data at destination instead of append?)
