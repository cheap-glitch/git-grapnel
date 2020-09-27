is_fork() {
	local repo_url="https://api.github.com/repos/cheap-glitch/$(basename "$(git root)")"
	if [[ "$(curl --silent "${repo_url}" | jq -r .fork)" == 'true' ]]; then return 1; else return 0; fi
}
