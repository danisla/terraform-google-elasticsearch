#!/usr/bin/env bash

fly -t tf set-pipeline -p tf-es-regression -c tests/pipelines/tf-es-regression.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-es-pull-requests -c tests/pipelines/tf-es-pull-requests.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-es-cleanup -c tests/pipelines/tf-es-cleanup.yaml -l tests/pipelines/values.yaml

fly -t tf expose-pipeline -p tf-es-regression
fly -t tf expose-pipeline -p tf-es-pull-requests