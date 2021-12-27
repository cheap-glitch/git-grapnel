# shellcheck shell=bash

# shellcheck source=src/helpers/is-run-by-git.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/is-run-by-git.sh"

confirm() {
	local prompt="$1"
	local default_answer="$2"

	# Assign stdin to the keyboard to allow reading user input
	# This is only needed when the script is run by git, and it otherwise complicates testing, hence the condition
	if is_run_by_git; then exec </dev/tty; fi

	# Wait for the user to answer
	while true; do
		read -r -n 1 -p "$(echo -e "${prompt}")" answer; echo
		case ${answer:-${default_answer}} in
			[nN*]) exit 1 ;;
			[yY*]) break ;;
			*) continue ;;
		esac
	done

	# Close stdin if needed
	if is_run_by_git; then exec <&-; fi
}
