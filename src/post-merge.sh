#!/usr/bin/env bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=helpers/is-changed.sh
source "${DIR}/helpers/is-changed.sh"

if [[ -f package-lock.json ]] && is_changed 'package-lock.json'; then npm clean-install; fi
