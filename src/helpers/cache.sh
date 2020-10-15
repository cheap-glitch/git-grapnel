# shellcheck shell=bash

CACHEDIR="${HOME}/.cache/git-grapnel"
CACHEFILE="${CACHEDIR}/data.json"

cache() {
	local key="$1"
	local command="$2"
	local value

	[[ ! -d "${CACHEDIR}"  ]] && mkdir -p "${CACHEDIR}"
	[[ ! -f "${CACHEFILE}" ]] && echo '{}' > "${CACHEFILE}"

	value="$(jq -r ".${key}" "${CACHEFILE}")"

	if [[ "${value}" == 'null' ]]; then
		value="$(bash -c "${command}")"
		jq ".${key} = \"${value}\"" "${CACHEFILE}" | sponge "${CACHEFILE}"
	fi

	echo -n "${value}"
}