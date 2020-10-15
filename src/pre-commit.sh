#!/bin/bash
set -eu -o pipefail
IFS=$'\n\t'

EXCLUDE_FROM_COMMITS='
.codecov.yml
.npmrc
.nyc_output
build
dist
node_modules
test-app
'

# Ensure the repo has a gitignore
if [[ ! -f .gitignore ]]; then echo "Need a .gitignore!"; exit 1; fi

# Ensure that some dangerous files and folders are not committed
for exclude in ${EXCLUDE_FROM_COMMITS}; do
	if rg -Fq "${exclude}" .gitignore; then continue; fi

	if [[ -f "${exclude}" ]]; then echo   "File '${exclude}' should be added to .gitignore!"; exit 1; fi
	if [[ -d "${exclude}" ]]; then echo "Folder '${exclude}' should be added to .gitignore!"; exit 1; fi
done
