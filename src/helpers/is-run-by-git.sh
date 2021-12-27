# shellcheck shell=bash

is_run_by_git() {
	local parent_command
	parent_command="$(ps --pid "${PPID}" --format cmd --no-headers)"

	[[ "${parent_command}" == '/usr/bin/git '* ]]
}
