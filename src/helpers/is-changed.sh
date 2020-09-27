is_changed() {
	local file="$1"
	git diff --name-only 'HEAD@{2}' HEAD | grep -Fq "^${file}$"
}
