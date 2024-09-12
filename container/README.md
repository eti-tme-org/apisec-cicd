# Docker container for Panoptica API Security CICD

## Instructions

Download (or copy from the parent) the API Security CICD CLI binary from the Panoptica [API Security](https://console.panoptica.app/settings/api_sec) Settings page.  You'll need the Linux version but the platform (AppleSilicon, AMD64, etc.) depends on that platform your container will run on.

Build the container locally:

```bash
docker build -f Dockerfile -t apisec:0.1 -t apisec:latest .
```

Set up the Panoptica API keys for the API Security CLI. This assumes that you have updated the contents of the file with the actual API Security keys from the Panoptica [API Security](https://console.panoptica.app/settings/api_sec) Settings page (see [README.md](../README.md)):

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

There are two bash scripts I wrote to make this super easy to use.  Their full descriptions are in the next section.  Your typical demo actions once you are running inside the container's bash shell are as follows.  The outputs of each command are the "summary" outputs.  If you'd like to see the JSON in it's full splendor, add "json" as the 2nd argument.

### Fetching existing, cached summary results

- ./get_job.sh oas
- ./get_job.sh 3rdparty
- ./get_job.sh fuzzer

### Fetching existing, cached detailed JSON results

- ./get_job.sh oas json
- ./get_job.sh 3rdparty json
- ./get_job.sh fuzzer json

### Generating new CICD jobs and fetching new summary results

- ./run_job.sh oas
- ./run_job.sh 3rdparty
- ./run_job.sh fuzzer

### Generating new CICD jobs and fetching new detailed results

- ./run_job.sh oas json
- ./run_job.sh 3rdparty json
- ./run_job.sh fuzzer json

### Example Outputs

You can see example outputs stored in this repo in the [outputs](../outputs) directory.

## Bash Script Descriptions

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