# Panoptica API Security CI/CD CLI Demo

## Setup local demo environment

Need to get an assortment of OpenAPI specification files to test. For general usage, I recommend getting the [Sock Shop OpenAPI Specs](https://github.com/eti-tme-org/sock-shop-specs).

```bash
git clone https://github.com/eti-tme-org/sock-shop-specs
```

For fuzz testing, we'll use the included [Pet Store](petstore/petstore.json) OpenAPI specification as that fuzz testing will be conducted using the Panoptica demo environment with sample application (petstore) loaded in a testing environment from which the API Security controller can test it.

For convenience, let's centralize the various service OAS contracts:

```bash
mkdir -p openapi
cd openapi
ln -s ../sock-shop-specs/*.json ./
ln -s ../petstore/petstore.json ./
cd ..
```

## Prepare the APIsec CLI

The assumption is that you are using the Panoptica demo environment (by invite only). As such, the API Security Controller is already installed into a K8s cluster and a sample application (petstore) is deployed for testing.

- Download the [CLI](https://console.panoptica.app/settings/api_sec) in the "API Security CLI" tab - assumption is it downloaded to "Downloads" folder.
- Generate [API Keys](https://console.panoptica.app/settings/api_sec) in the "API Security CLI" tab - but only if they don't already exist.
- Update the [cicd.api.keys](config/cicd.api.keys) with the generated keys.

Relocate and change permission on the CLI:

```bash
mv ${HOME}/Downloads/apisec_cli ${PWD}
chmod u+x apisec_cli
```

Check out the CLI help menus:

```bash
./apisec_cli
./apisec_cli apisec-job
```

## Configure SaaS platform access and test

Deploy the API key pair needed to access the Panoptica SaaS:

```bash
source config/cicd.api.keys
```

List available API controllers.  This tests the API keys as well as confirms that the controller exists in the environment.

```bash
./apisec_cli apisec-job list-controllers
```

Two important items of note regarding listing controllers:

1. The controller is only required for fuzz testing so you may get no controllers returned (but without error)
2. If you are using a MacOS system, your download may be blocked for security reasons.  You need to go to System Preferences->Privacy & Security to permit using the binary.

## Submit demonstration jobs to Panoptica

These first two tasks do not require an API Security controller to be deployed and running in the customer environment.

### Submit a scoring job

```bash
./apisec_cli apisec-job start-oas-scoring openapi/carts.json

# Copy job id string into env var
export JOB_ID=....
```

Check on job status (poll means wait for completion):

```bash
./apisec_cli apisec-job get --poll ${JOB_ID}
```

Get summary of findings:

```bash
./apisec_cli apisec-job get --summary ${JOB_ID}
```

Get JSON output of findings.  Note: argument order is important.  Also, the results include far more information that summary report above:

```bash
./apisec_cli apisec-job --json get --summary ${JOB_ID}
```

### 3rd party API scoring

```bash
./apisec_cli apisec-job start-third-party-api-scoring --poll --url https://api.weather.gov

export JOB_ID=...
```

Fetch results:

```bash
./src/apisec_cli apisec-job get --summary ${JOB_ID}
```

Get JSON output of findings.  Note: argument order is important.  Also, the results include far more information that summary report above:

```bash
./apisec_cli apisec-job --json get --summary ${JOB_ID}
```

### API Fuzz testing

This portion of the demo does, in fact, require an API Security controller to be deployed in a Kubernetes cluster. That controller must also have network reachability to the API service to be fuzz testing.

The below example assumes the Panoptica demo environment set up (invite only). 

```bash
export DEMO_FUZZ_URL="http://mypetstore.fuzzer:5000"
export DEMO_FUZZ_OAS="openapi/petstore.json"

export CONTROLLER_ID=$(./apisec_cli apisec-job list-controllers | sed '1d' | head -1 | awk '{print $1;}')

./src/apisec_cli apisec-job start-fuzzing --poll \
     --controller-id ${CONTROLLER_ID} \
     --fuzzing-depth Quick \
     --url ${DEMO_FUZZ_URL} ${DEMO_FUZZ_OAS} 
```

Fetch results:

```bash
./src/apisec_cli apisec-job get --summary ${JOB_ID}
```

Get JSON output of findings.  Note: argument order is important.  Also, the results include far more information that summary report above:

```bash
./apisec_cli apisec-job --json get --summary ${JOB_ID}
```

## Example Outputs

If for whatever reason, you can't access the Panoptica SaaS or network connectivity is otherwise unavailable, the following output files are available:

- [Screen Capture of Demo](outputs/apisec.cicd.cast): Use [Asciinema](https://asciinema.org) to play the recording.
- carts API OAS Analysis: [summary][outputs/carts.oas.findings.txt] and [JSON details](outputs/carts.oas.findings.json)
- api.weather.gov 3rd Party Assessment: [summary][outputs/weather.api.findings.txt] and [JSON details](outputs/weather.api.findings.json)
- petstore API Fuzzing: [summary][outputs/petstore.fuzzing.findings.txt] and [JSON details](outputs/petstore.fuzzing.findings.json)