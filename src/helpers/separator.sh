# shellcheck shell=bash

separator() {
	echo -en "\e[1;30m"
	for (( i=COLUMNS; i>0; i-- )); do echo -n '┈'; done
	echo -en "\e[0m"
}
