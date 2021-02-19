#!/usr/bin/env bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=helpers/echo-bold.sh
source "${DIR}/helpers/echo-bold.sh"
# shellcheck source=helpers/is-fork.sh
source "${DIR}/helpers/is-fork.sh"
# shellcheck source=helpers/run-npm-script.sh
source "${DIR}/helpers/run-npm-script.sh"

# Node
if [[ -f package.json ]]; then
	if is_fork || [[ "$(jq --raw-output --monochrome-output '."git-hooks"."pre-push".noVerify // false' package.json)" == 'true' ]]; then
		echo_bold "Skipping lints and tests!\n"
	else
		run_npm_script 'lint'
		run_npm_script 'coverage' 'test'
	fi
	run_npm_script 'coverage:upload' 'upload:coverage'

	exit 0
fi

# Rust
if [[ -f Cargo.toml ]]; then
	cargo clippy -- -W clippy::cargo
	cargo test

	exit 0
fi

# Deno
if [[ -f index.ts ]]; then
	deno lint --unstable
	deno test --coverage --unstable

	exit 0
fi
