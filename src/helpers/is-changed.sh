# shellcheck shell=bash

is_changed() {
	local file="$1"
	git diff --name-only 'HEAD@{2}' HEAD | rg -q "^${file}$"
}
