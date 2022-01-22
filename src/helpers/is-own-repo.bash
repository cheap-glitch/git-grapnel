is_own_repo() {
	# Check that the local repo is not a GitHub fork (no `upstream` branch)
	# and is not owned by someone else (the `origin` URL contains the user's name)
	[[ -z "$(git remote)" ]] || \
	(! git remote get-url upstream &>/dev/null && git remote get-url origin 2>/dev/null | rg --quiet --fixed-strings "$(git config user.name)/")
}
