#!/bin/bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=src/helpers/is-fork.sh
source "${DIR}/helpers/is-fork.sh"
# shellcheck source=src/helpers/run-npm-script.sh
source "${DIR}/helpers/run-npm-script.sh"

# Node
if [[ -f package.json ]]; then
	if is_fork || [[ "$(jq --raw-output --monochrome-output '."git-hooks"."pre-push".noVerify // false' package.json)" == 'true' ]]; then
		echo_bold "Skipping lints and tests!"
		exit 0
	fi

	run_npm_script 'lint'
	run_npm_script 'test'
	run_npm_script 'upload:coverage'

	exit 0
fi

# Rust
if [[ -f Cargo.toml ]]; then
	cargo clippy -- -W clippy::cargo
	cargo test

	exit 0
fi
