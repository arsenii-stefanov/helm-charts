#!/bin/bash

#set -eEu -o pipefail

function helm_lint() {
  docker run \
       --rm \
       -v "${SRCROOT}:${CONT_WORKDIR}" \
       --entrypoint ct \
       -w "${CONT_WORKDIR}" \
       "${CONT_IMAGE_REPO}:${CONT_IMAGE_TAG}" \
       lint \
       --config "${HELM_CONFIG}" \
       --lint-conf "${LINT_CONFIG}" \
       --debug
}

function helm_create_pkgs() {
  helm package ${HELM_CHART_DIR_WILDCARD}
  helm repo index --url "${HELM_REPO_URL}" --merge "${HELM_REPO_INDEX}" "${HELM_REPO_ROOT}"
}
