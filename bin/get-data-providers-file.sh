#!/usr/bin/env bash

set -euo pipefail

function usage {
    echo "Usage: $0 -t <gitlab token> -r <repo name> -j <job name> -f <file path>"; exit 1;
}

GITLAB_TOKEN=""
DP_REPOSITORY_ID=""
JOB_NAME=""
FILE_PATH=""

while getopts "t:r:j:f:" opt; do
    case $opt in
        t)
            GITLAB_TOKEN=$OPTARG
        ;;
        r)
            DP_REPOSITORY_ID=$(echo "$OPTARG" | sed "s/\//%2F/g")
        ;;
        j)
            JOB_NAME=$OPTARG
        ;;
        f)
            FILE_PATH=$OPTARG
        ;;
    esac
done

if [[ -z "${GITLAB_TOKEN}" || -z "${DP_REPOSITORY_ID}"  || -z "${JOB_NAME}" || -z "${FILE_PATH}" ]]; then
    usage
fi

function project_api () {
    curl --location \
        --silent \
        --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
        "https://gitlab.com/api/v4/projects/${DP_REPOSITORY_ID}$1"
}

#this is currently limited to 100 last pipelines
function get_latest_completed_job_id_by_name
{
    local JOB_NAME=$1
    PIPELINES=$(project_api "/pipelines?ref=master&per_page=100" 2> /dev/null)

    for (( i=0; i<$(echo "$PIPELINES" | jq -r "length"); i++ ))
    do
        PIPELINE_ID=$(echo "$PIPELINES" | jq --argjson i "$i" '.[$i].id')
        PIPELINE_JOB_ID=$(project_api "/pipelines/$PIPELINE_ID/jobs?scope=success" 2> /dev/null | jq --arg JOB_NAME "$JOB_NAME" '.[] | select(.name == $JOB_NAME) | .id')

        if [[ ! -z "$PIPELINE_JOB_ID" ]]; then
            echo "$PIPELINE_JOB_ID"
            break;
        fi
    done
}

JOB_ID=$(get_latest_completed_job_id_by_name "${JOB_NAME}")
project_api "/jobs/${JOB_ID}/artifacts/${FILE_PATH}"
