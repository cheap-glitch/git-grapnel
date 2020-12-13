# shellcheck shell=bash

run_npm_script() {
	local script_name="$1"

	if jq --exit-status ".scripts.\"${script_name}\"" package.json &> /dev/null; then
		npm run "${script_name}"
	fi
}
