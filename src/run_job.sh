#!/usr/bin/env bash

list_controllers() {
    ./apisec_cli apisec-job list-controllers | sed "1d" | awk '{print $1;}'
    exit 0
}

get_job_data() {
    JOB_ID=$1
    if [ "$2" == "json" ]; then
        ./apisec_cli apisec-job --json get --summary "${JOB_ID}" | jq
    else
        ./apisec_cli apisec-job get --summary "${JOB_ID}"
    fi
}

get_last_job() {
    get_job_data $(./apisec_cli apisec-job list --is-desc | grep "$1" | awk '/Completed/ { print $1; }' | head -1) "$2"
}

get_last_fuzz_job() {
    get_last_job "FuzzingJob" "$1"
    exit 0
}

get_last_oas_job() {
    get_last_job "OasScoringJob" "$1"
    exit 0
}

get_last_third_job() {
    get_last_job "ThirdPartyApiScoringJob" "$1"
    exit 0
}

if [ "$1" == "list_controllers" ]; then
    list_controllers
fi

if [ "$1" == "fuzzer" ]; then
    DEMO_FUZZ_URL="http://mypetstore.fuzzer:5000"
    DEMO_FUZZ_OAS="openapi/petstore.json"
    CONTROLLER_ID=$(./apisec_cli apisec-job list-controllers | sed '1d' | head -1 | awk '{print $1;}')

    echo "Starting fuzzing on ${DEMO_FUZZ_URL} via controller ${CONTROLLER_ID}"
    
    JOB_OUTPUT=$(./apisec_cli apisec-job start-fuzzing --poll --controller-id ${CONTROLLER_ID} --fuzzing-depth Quick --url ${DEMO_FUZZ_URL} ${DEMO_FUZZ_OAS} 2>&1)

    echo ${JOB_OUTPUT}

    get_last_fuzz_job "$2"
fi

if [ "$1" == "oas" ]; then
    echo "Submitting carts.json for OAS scoring"
    JOB_OUTPUT=$(./apisec_cli apisec-job start-oas-scoring openapi/carts.json 2>&1)
    echo "${JOB_OUTPUT}"

    JOB_ID=$(echo ${JOB_OUTPUT} | cut -d\" -f2)
    echo "Job ID: ${JOB_ID}"
    JOB_OUTPUT=$(./apisec_cli apisec-job get --poll ${JOB_ID})

    get_last_oas_job "$2"
fi

if [ "$1" == "3rdparty" ]; then
    echo "Submitting api.weather.gov for scoring"
    JOB_OUTPUT=$(./apisec_cli apisec-job start-third-party-api-scoring --poll --url https://api.weather.gov)
    echo "${JOB_OUTPUT}"

    get_last_third_job "$1"
fi

# Help options
echo ""
echo "Command help options"
echo ""
echo "run_job.sh TYPE [json]"
echo ""
echo "TYPE := fuzzer, oas, 3rdparty, list_controllers"
echo ""
echo "if option 'json' second argument, detailed JSON text printed"
echo "otherwise, summary of results printed"
echo ""
echo ""
echo "Note: this script helps print LIVE results from previous jobs"
echo "      Fuzzing jobs take a few minutes so be patient"
echo ""
