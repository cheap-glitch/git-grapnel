#!/bin/bash
set -eu -o pipefail
IFS=$'\n\t'

npm_scripts_have() {
	jq -e .scripts."\"$1\"" package.json &> /dev/null
}

#
# JavaScript
#
if [[ -f package.json ]]; then
	# Lint the code and abort the push on error
	if npm_scripts_have 'lint'; then npm run lint; fi

	# Report the code coverage (and implicitly run the tests)
	if npm_scripts_have 'coverage:report'; then npm run coverage:report

	# If there is no coverage command, just run the tests
	elif npm_scripts_have 'test'; then npm test; fi
fi

#
# Rust
#
if [[ -f Cargo.toml ]]; then
	# Lint the code
	cargo clippy -- -W clippy::pedantic -W clippy::cargo

	# Run the tests and abort the push on error
	cargo test
fi
