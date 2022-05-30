#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$0")

for script in $(ls "${SCRIPT_DIR}"/tools/apply-*.sh); do
    echo "Executing: ${script}"
    /bin/bash "${script}"
done
