contains() {
	local list="$1"
	local string="$2"
	[[ "${list}" =~ (^|[[:space:]])"${string}"([[:space:]]|$) ]]
}
