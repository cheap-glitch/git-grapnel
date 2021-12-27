#!/usr/bin/env bash
set -eu -o pipefail
shopt -u expand_aliases
IFS=$'\n\t'

bats test
