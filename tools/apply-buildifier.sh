#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$0")

buildifier -r "${SCRIPT_DIR}/../"
