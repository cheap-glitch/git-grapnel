#!/bin/bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=src/helpers/is-changed.sh
source "${DIR}/helpers/is-changed.sh"

if is_changed 'package.json'; then npm install; fi
