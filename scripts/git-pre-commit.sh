#!/bin/bash

set -eEu -o pipefail

### Import
source scripts/aux.sh
source scripts/helm_scripts.sh

SRCROOT="$(cd "$(dirname "$0")/../.." && pwd)"  ### git repo root

### Lint vars
CONT_IMAGE_REPO="quay.io/helmpack/chart-testing"
CONT_IMAGE_TAG="v3.3.1"
CONT_WORKDIR="/workdir"
CONFIG_DIR=".github/configs"
HELM_CONFIG="${CONFIG_DIR}/ct-lint.yaml"
LINT_CONFIG="${CONFIG_DIR}/lintconf.yaml"

### Package vars
HELM_REPO_URL="https://arsenii-stefanov.github.io/helm-charts"
HELM_REPO_INDEX="index.yaml"
HELM_CHART_DIR_ROOT="charts"
HELM_CHART_DIR_WILDCARD="${HELM_CHART_DIR_ROOT}/*"
HELM_REPO_ROOT="."
GH_PAGES_BRANCH="gh-pages"

function cur_branch() {
  local branch="$(git rev-parse --abbrev-ref HEAD)"
  echo "${branch}"
}

### Main
c_branch="$(cur_branch)"

if [ "${c_branch}" != "${GH_PAGES_BRANCH}" ]; then
  echo -e "[${LYLW}STAGE 1${NOCOLOR}] Lint"
  helm_lint
  echo -e "${LGREEN}Helm chart(s) validated successfully${NOCOLOR}"

  ### Ensure that the current working directory is inside the work tree of the repository
  is_inside_work_tree="$(git rev-parse --is-inside-work-tree)"
  if "${is_inside_work_tree}"; then
    commit_id="$(git merge-base origin/${c_branch} HEAD)"
    helm_changes="$(git diff --find-renames --name-only ${commit_id} -- ${HELM_CHART_DIR_ROOT})"
    if [ ! -z "${helm_changes// }" ]; then
      echo -e "[${LYLW}STAGE 2${NOCOLOR}] Package"
      helm_create_pkgs
      echo -e "${LGREEN}Helm package(s) created successfully${NOCOLOR}"
    else
      echo "${LCYAN}No changes to Helm charts detected. Nothing to package${NOCOLOR}"
    fi
  fi
fi
