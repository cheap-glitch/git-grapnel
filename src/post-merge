#!/bin/bash

# This hook is invoked by git-merge, which happens
# e.g. when a pull is done on a local repository.

DIR="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck source=src/helpers/is-changed.sh
source "${DIR}/helpers/is-changed.sh"

if is_changed 'package.json'; then npm install; fi
