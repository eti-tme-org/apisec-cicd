# Docker container for Panoptica API Security CICD

## Instructions

Build the container locally:

```bash
docker build -f Dockerfile -t apisec:0.1 -t apisec:latest .
```

Set up the Panoptica API keys for the API Security CLI:

```bash
source ../config/cicd.api.keys
```

Create the local OpenAPI spec folder (assumes you followed [README.md](../README.md) instructions for building the OpenAPI folder):

```bash
mkdir -p openapi
cp ../openapi/*.json openapi
```

If you didn't build the central openapi folder above, simply find the carts.json (in the sock-shop-specs) and the petstore.json (parent directory) swagger files and copy them into an openapi folder.

Start the container and start the container's bash shell:

```bash
docker run -it \
    -e PANOPTICA_CLI_ACCESS_KEY="${PANOPTICA_CLI_ACCESS_KEY}" \
    -e PANOPTICA_CLI_SECRET_KEY="${PANOPTICA_CLI_SECRET_KEY}" \
    -v ${PWD}/openapi/:/home/nobody/openapi/ \
    apisec:latest bash
```

## Ways to use the API Security container

- There is a **get_job.sh** script for fetching previously cached API security jobs (best for conferences, and quick review of outputs).

```
$ ./get_job.sh 

Command help options

get_job.sh TYPE [json]

TYPE := fuzzer, oas, 3rdparty, list_controllers

if option 'json' second argument, detailed JSON text printed
otherwise, summary of results printed


Note: this script helps print cached results from previous jobs
```

- There is a **run_job.sh** script for interactively running API security CICD jobs, including the fuzzer.

```
$ ./run_job.sh 

Command help options

run_job.sh TYPE [json]

TYPE := fuzzer, oas, 3rdparty, list_controllers

if option 'json' second argument, detailed JSON text printed
otherwise, summary of results printed


Note: this script helps print LIVE results from previous jobs
      Fuzzing jobs take a few minutes so be patient
```
