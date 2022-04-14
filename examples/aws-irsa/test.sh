#!/bin/bash

set -eEu -o pipefail

HELM_CHART_DIR='../../charts/aws-irsa'
HELM_RELEASE_NAME='test'
HELM_VALUES_FILE='values.yaml'
HELM_OUTPUT_DIR='results'

SRCROOT="$(dirname "$0")"

cd "${SRCROOT}"
echo "Changed directory to $(pwd)"

helm template --release-name "${HELM_RELEASE_NAME}" --values "${HELM_VALUES_FILE}" --output-dir "${HELM_OUTPUT_DIR}" "${HELM_CHART_DIR}"

echo "See generated K8s manifests in $(pwd)/${HELM_OUTPUT_DIR}"
