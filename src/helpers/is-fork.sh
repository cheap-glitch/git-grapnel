is_fork() {
	[[ "$(curl --silent "https://api.github.com/repos/cheap-glitch/$(basename "$(git root)")" | jq -r .fork)" == 'true' ]]
}
