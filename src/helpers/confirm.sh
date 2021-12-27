# shellcheck shell=bash

# shellcheck source=src/helpers/format.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/format.sh"
# shellcheck source=src/helpers/is-run-by-git.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/is-run-by-git.sh"

confirm() {
	local prompt default_answer
	default_answer="${2:-y}"
	prompt="${1:-}? ${FMT_FG_BLACK}$(if [[ "${default_answer}" == 'y' ]]; then echo '(Y/n)'; else echo '(y/N)'; fi)${FMT_RESET} "

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
