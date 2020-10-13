#!/bin/bash
set -eu -o pipefail
IFS=$'\n\t'

if [[ ! -f package.json ]]; then exit 0; fi

scripts_have() {
	if jq -e '.scripts."'"$1"'"' package.json > /dev/null; then return 0; else return 1; fi
}

if scripts_have 'lint'; then
	if ! npm run lint; then exit 1; fi
fi

# Report the code coverage (and implicitly run the tests)
if scripts_have 'coverage:report'; then
	if ! npm run coverage:report; then exit 1; fi
# If there is no coverage command, just run the tests
elif scripts_have 'test'; then
	if ! npm test; then exit 1; fi
fi
