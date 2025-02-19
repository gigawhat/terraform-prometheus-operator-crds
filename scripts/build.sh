#!/bin/bash

set -eux

REPO_TAG="0.80.1"
REPO_NAME="prometheus-operator"
REPO_URL=https://github.com/prometheus-operator/${REPO_NAME}.git
TMP_DIR=$(mktemp -d)

# Clone the operator repository
git clone --branch "v${REPO_TAG}" --depth=1 "${REPO_URL}" "${TMP_DIR}"

# Get the CRDs from the bundle
yq '. |  select(.kind == "CustomResourceDefinition")' ${TMP_DIR}/bundle.yaml > crds.yaml

# Convert the yaml to tf
tfk8s -f crds.yaml -o main.tf
