# shellcheck shell=bash

# shellcheck source=src/helpers/cache.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/cache.sh"

is_fork() {
	local repo_url
	repo_url="https://api.github.com/repos/cheap-glitch/$(basename "$(pwd)")"

	[[ "$(cache "isRepo.\"${repo_url}\"" "curl --silent ${repo_url} | jq -r .fork")" == 'true' ]]
}
