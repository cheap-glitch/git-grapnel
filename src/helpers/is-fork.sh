# shellcheck shell=bash

# shellcheck source=src/helpers/cache.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/cache.sh"

is_fork() {
	local repo_url
	local repo_name

	repo_name="$(basename "$(pwd)")"
	repo_url="https://api.github.com/repos/$(git config --get user.name)/${repo_name}"

	[[ "$(cache "isFork.\"${repo_name}\"" "curl --silent ${repo_url} | jq --raw-output '.fork // false'")" == 'true' ]]
}
