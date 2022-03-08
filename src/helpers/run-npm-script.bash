run_first_available_npm_script() {
	for script in "${@}"; do
		if jq --exit-status ".scripts.\"${script}\"" package.json &>/dev/null; then
			npm run "${script}"
			return
		fi
	done
}
