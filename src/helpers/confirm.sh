# shellcheck shell=bash

confirm() {
	local prompt="$1"
	local default_answer="$2"

	# Assign STDIN to the keyboard to allow reading user input
	exec < /dev/tty

	# Wait for the user to answer
	while true; do
		read -r -n 1 -p "$(echo -e "${prompt}? \e[1;30m$(if [[ "${default_answer}" == 'y' ]]; then echo '(Y/n)'; else echo '(y/N)'; fi)\e[0m ")" answer
		echo ""

		if [[ -z "${answer}" ]]; then answer="${default_answer}"; fi

		case ${answer} in
			[Nn]) exit 1   ;;
			[Yy]) break    ;;
			*)    continue ;;
		esac
	done

	# Close STDIN
	exec <&-
}
