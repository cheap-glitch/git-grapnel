#!/usr/bin/env bash
set -eu -o pipefail
IFS=$'\n\t'

DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
# shellcheck source=helpers/confirm.sh
source "${DIR}/helpers/confirm.sh"
# shellcheck source=helpers/contains.sh
source "${DIR}/helpers/contains.sh"
# shellcheck source=helpers/is-fork.sh
source "${DIR}/helpers/is-fork.sh"

if [[ -f package.json ]] && [[ "$(jq --raw-output --monochrome-output '."git-hooks"."commit-msg".noVerify // false' package.json)" == 'true' ]]; then exit 0; fi

TMPFILE="$1"
MESSAGE="$(rg --invert-match '^#' "${TMPFILE}")"
SPELLCHECK_LANG='en'
declare -A COMMIT_TYPES=(
	[build]='🔨'
	[chore]='🔧'
	[config]='🔩'
	[deploy]='🚀'
	[docs]='📖'
	[feat]='🌱'
	[fix]='🐛'
	[init]='🎉️'
	[lint]='🚨'
	[perf]='🐎'
	[refactor]='♻️ '
	[release]='📦'
	[revert]='🗑️'
	[style]='✨'
	[test]='🚩'
	[ui]='🎨'
)

# Do nothing if the message is exactly the same as the one from the latest commit (meaning `git commit --amend` or `git fixup` has been used)
if git rev-parse --is-inside-work-tree &> /dev/null && git rev-list HEAD &> /dev/null && [[ "${MESSAGE}" == "$(git rev-list -n 1 --format=%B HEAD | sed '1d')" ]]; then exit 0; fi

# Only enforce the Conventional Commits format in my own repos
if ! is_fork; then
	# Check that the message is correctly formatted according to the Conventional Commit specs
	if [[ ! "${MESSAGE}" =~ ^(.{1,2} {1,2})?(([a-z]+)!?(\([a-z]+\))?):[[:space:]]([0-9A-Z].+)$ ]]; then
		echo "Please use the following format for your commit messages:"
		echo "<type>[!][(scope)]: <Description>"
		exit 1
	fi

	# Get the commit type and description from the matching groups
	label="${BASH_REMATCH[2]:-}"
	type="${BASH_REMATCH[3]:-}"
	description="${BASH_REMATCH[5]:-}"
	summary="$(echo -e "${description}" | sed 1q)"

	# Check that the type is in the list of predefined commit types
	if ! contains "${!COMMIT_TYPES[*]}" "${type}"; then
		echo -e "Please use one of the following commit types for your message:\n$(echo "${!COMMIT_TYPES[*]}" | tr ' ' '\n' | sort | ts '  *')"
		exit 1
	fi

	# Check that the summary does NOT end with a period
	if [[ "${summary: -1}" == '.' ]]; then
		echo "Please remove the period at the end of the summary"
		exit 1
	fi
else
	description="${MESSAGE}"
fi

# Convert pairs of simple quotes into single back quotes in the description
description="${description//\'\'/\`}"

# Check the spelling of the description
typos=()
for typo in $(echo "${description//\\n/ }" | aspell list --lang="${SPELLCHECK_LANG}" --add-extra-dicts="${DIR}/dict/commit-msg"); do
	# Ignore misspelled words and function names inside back quotes
	if ! contains "${description}" '`'"${typo}"'`' && ! contains "${description}" '`'"${typo}"'()`'; then typos+=("${typo}"); fi
done

# Highlight the misspelled words in red and prompt to ignore the mistakes or not
if [[ ${#typos[@]} -ge 1 ]]; then
	hl="${description}"
	for typo in "${typos[@]}"; do hl="$(echo -e "${hl}" | sed 's/'"${typo}"'/'"\\\e[31m${typo}\\\e[0m"'/g')"; done

	echo -e "Some spelling mistakes were detected:"
	echo -e "\n${hl}\n"
	confirm "Still commit with this message" "y"
fi

if ! is_fork; then
	# Add the corresponding emoji before the type and save the modified message
	echo -ne "${COMMIT_TYPES[${type}]} ${label}: ${description}" > "${TMPFILE}"
else
	echo -ne "${description}" > "${TMPFILE}"
fi
