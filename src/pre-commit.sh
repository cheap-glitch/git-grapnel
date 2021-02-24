#!/usr/bin/env bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=helpers/is-fork.sh
source "${DIR}/helpers/is-fork.sh"

EXCLUDE_FROM_COMMITS='
.coverage/
.nyc_output/
build/
dist/
node_modules/
test-app/
.codecov.yml
.coveralls.yml
.env
.npmrc
'

if ! is_fork; then
	# Ensure the repo has a .gitignore
	if [[ ! -f .gitignore ]]; then echo "Need a .gitignore!"; exit 1; fi

	# Ensure that some dangerous files and folders are not committed
	for exclude in ${EXCLUDE_FROM_COMMITS}; do
		if rg --fixed-strings --quiet "${exclude}" .gitignore; then continue; fi

		if [[ -f "${exclude}" ]]; then echo   "File '${exclude}' should be added to .gitignore!"; exit 1; fi
		if [[ -d "${exclude}" ]]; then echo "Folder '${exclude}' should be added to .gitignore!"; exit 1; fi
	done

	# Lint staged JavaScript/TypeScript files
	if jq --exit-status .devDependencies.eslint package.json &> /dev/null; then
		readarray -t files <<< "$(git --no-pager diff --staged --name-only | rg '\.(js|ts)$')" || true
		if [[ ${#files[@]} -gt 0 && "${files[0]}" != '' ]]; then npx eslint "${files[@]}"; fi
	fi
fi
