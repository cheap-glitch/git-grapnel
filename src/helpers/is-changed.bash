is_changed() {
	mapfile -t changed_files < <(git diff --name-only 'HEAD@{2}..')

	for file in "${changed_files[@]}"; do
		if [[ "${file}" == "${1}" ]]; then return 1; fi
	done
}
