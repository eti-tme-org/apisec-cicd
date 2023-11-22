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
    get_last_fuzz_job "$2"
fi

if [ "$1" == "oas" ]; then
    get_last_oas_job "$2"
fi

if [ "$1" == "3rdparty" ]; then
    get_last_third_job "$2"
fi

# Help options
echo ""
echo "Command help options"
echo ""
echo "get_job.sh TYPE [json]"
echo ""
echo "TYPE := fuzzer, oas, 3rdparty, list_controllers"
echo ""
echo "if option 'json' second argument, detailed JSON text printed"
echo "otherwise, summary of results printed"
echo ""
echo ""
echo "Note: this script helps print cached results from previous jobs"
echo ""
