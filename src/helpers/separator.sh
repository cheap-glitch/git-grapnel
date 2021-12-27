# shellcheck shell=bash

# shellcheck source=src/helpers/format.sh
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/format.sh"

separator=''
for (( i=COLUMNS; i>0; i-- )); do separator="${separator}┈"; done

print_separator() {
	echo -en "${FMT_FG_BLACK}${separator}${FMT_RESET}"
}
