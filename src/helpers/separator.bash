# shellcheck source=src/helpers/format.bash
source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/format.bash"

separator=''
for (( i=COLUMNS; i>0; i-- )); do separator="${separator}┈"; done

print_separator() {
	echo -en "${FMT_FG_BLACK}${separator}${FMT_RESET}"
}
