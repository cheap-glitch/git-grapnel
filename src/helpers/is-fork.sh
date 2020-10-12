# shellcheck shell=bash

is_fork() {
	local repo_url
	repo_url="https://api.github.com/repos/cheap-glitch/$(basename "$(git root)")"

	if [[ "$(curl --silent "${repo_url}" | jq -r .fork)" == 'true' ]]; then echo 1; else echo 0; fi
}
