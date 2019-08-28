#!/usr/bin/env bash

set -euo pipefail

mkdir -p dist

./bin/get-data-providers-file.sh \
    -t ${GITLAB_TOKEN} \
    -r ${REPO_NAME} \
    -j ${JOB_NAME} \
    -f ${FILE_PATH} > dist/artifact.yml