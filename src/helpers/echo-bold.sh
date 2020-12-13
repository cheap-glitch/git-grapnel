# shellcheck shell=bash

echo_bold() {
	local message="$1"

	echo -e "\e[1m${message}\e[0m"
}
