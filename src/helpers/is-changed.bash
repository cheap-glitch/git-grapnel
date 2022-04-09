is_changed() {
	mapfile -t changed_files < <(git diff --name-only 'HEAD@{2}..')

	for file in "${changed_files[@]}"; do
		if [[ "$(basename "${file}")" == "${1}" ]]; then return 0; fi
	done

	return 1
}
