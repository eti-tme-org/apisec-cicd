#!/usr/bin/env bash

### OAS Scoring Job
export JOB_ID=$(./apisec_cli apisec-job start-oas-scoring openapi/bestbags/user.json 2>&1 | cut -d\" -f2)

./apisec_cli apisec-job get --summary ${JOB_ID}

### OAS Max Length example
./apisec_cli apisec-job --json get --summary ${JOB_ID} | jq '.items[]|select(.description|contains("maximum length"))'

### 3rd party score
export JOB_ID=$(./apisec_cli apisec-job start-third-party-api-scoring --poll --url https://api.weather.gov 2>&1 | cut -d\" -f2)

./apisec_cli apisec-job get --summary ${JOB_ID}

### first result
./apisec_cli apisec-job --json get --summary ${JOB_ID} | jq 'first(.items[])'

### Fuzz testing
export DEMO_FUZZ_URL="http://mypetstore.fuzzer:5000"
export DEMO_FUZZ_OAS="openapi/petstore.json"
export CONTROLLER_ID=$(./apisec_cli apisec-job list-controllers | sed '1d' | head -1 | awk '{print $1;}')
export JOB_ID=$(./apisec_cli apisec-job start-fuzzing --controller-id ${CONTROLLER_ID} --fuzzing-depth Quick --url ${DEMO_FUZZ_URL} ${DEMO_FUZZ_OAS} 2>&1 | cut -d\" -f2)
