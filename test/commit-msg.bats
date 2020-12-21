#!/usr/bin/env bats

COMMIT_MSG_FILE="${BATS_TMPDIR}/commit-message"

commit() {
	echo "$1" > "${COMMIT_MSG_FILE}"
	echo "${COMMIT_MSG_FILE}"
}

@test "incorrectly formatted commit messages trigger an error" { # {{{

	run ./src/commit-msg.sh "$(commit "feat Add a new feature")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg.sh "$(commit "docs:Update readme")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg.sh "$(commit "style: format the code base")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg.sh "$(commit "fix(core: Fix a bug")"
	[ "${status}" -eq 1 ]

	# run ./src/commit-msg.sh "$(commit "chore: Update dependencies.")"
	# [ "${status}" -eq 1 ]

} # }}}

@test "wrong commit types trigger an error" { # {{{

	run ./src/commit-msg.sh "$(commit "bug: Fix a bug")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg.sh "$(commit "ref: Refactor main module")"
	[ "${status}" -eq 1 ]

} # }}}

@test "valid commit messages don't trigger an error" { # {{{

	./src/commit-msg.sh "$(commit "feat: Add a feature")"

	./src/commit-msg.sh "$(commit "test: Improve the tests")"

	./src/commit-msg.sh "$(commit "fix: Fix a bug")"

	./src/commit-msg.sh "$(commit "feat(parser): Add a feature in the parser")"

	./src/commit-msg.sh "$(commit "refactor!: Create a breaking change")"

	./src/commit-msg.sh "$(commit "revert!(core): Another breaking change")"

} # }}}

@test "emojis are automatically added before the commit type" { # {{{

	./src/commit-msg.sh "$(commit "feat: Add a feature")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "🌱 feat: Add a feature" ]

	./src/commit-msg.sh "$(commit "fix: Fix a bug")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "🐛 fix: Fix a bug" ]

	./src/commit-msg.sh "$(commit "chore: Boring stuff")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "🔧 chore: Boring stuff" ]

	./src/commit-msg.sh "$(commit "config: Update config")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "🔩 config: Update config" ]

	./src/commit-msg.sh "$(commit "docs: Update readme")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "📖 docs: Update readme" ]

} # }}}

@test "multi-line commits work too" { # {{{

	./src/commit-msg.sh "$(commit "feat: Add a feature\n\nThis is a new feature!")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "$(echo -e "🌱 feat: Add a feature\n\nThis is a new feature!")" ]

} # }}}

@test "emojis before the commit type are ignored" { # {{{

	./src/commit-msg.sh "$(commit "🌱 feat: Add a feature")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "🌱 feat: Add a feature" ]

	./src/commit-msg.sh "$(commit "📖 docs: Update readme")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "📖 docs: Update readme" ]

	./src/commit-msg.sh "$(commit "♻️  refactor: Rename all functions")"
	[ "$(cat "${COMMIT_MSG_FILE}")" == "♻️  refactor: Rename all functions" ]

} # }}}
