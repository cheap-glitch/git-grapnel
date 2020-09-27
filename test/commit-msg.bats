#!/usr/bin/env bats

commit() {
	echo "$1" > "${BATS_TMPDIR}/message"
	echo "${BATS_TMPDIR}/message"
}

@test "incorrectly formatted commit messages trigger an error" {
	run ./src/commit-msg "$(commit "feat Add a new feature")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg "$(commit "docs:Update readme")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg "$(commit "style: format the code base")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg "$(commit "fix(core: Fix a bug")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg "$(commit "🔧 chore: Update dependencies")"
	[ "${status}" -eq 1 ]
}

@test "wrong commit types trigger an error" {
	run ./src/commit-msg "$(commit "bug: Fix a bug")"
	[ "${status}" -eq 1 ]

	run ./src/commit-msg "$(commit "ref: Refactor main module")"
	[ "${status}" -eq 1 ]
}

@test "valid commit messages don't trigger an error" {
	run ./src/commit-msg "$(commit "feat: Add a feature")"
	[ "${status}" -eq 0 ]

	run ./src/commit-msg "$(commit "test: Improve the tests")"
	[ "${status}" -eq 0 ]

	run ./src/commit-msg "$(commit "fix: Fix a bug")"
	[ "${status}" -eq 0 ]

	run ./src/commit-msg "$(commit "feat(parser): Add a feature in the parser")"
	[ "${status}" -eq 0 ]

	run ./src/commit-msg "$(commit "refactor!: Create a breaking change")"
	[ "${status}" -eq 0 ]

	run ./src/commit-msg "$(commit "revert!(core): Another breaking change")"
	[ "${status}" -eq 0 ]
}

@test "emoji are automatically added before the commit type" {
	run ./src/commit-msg "$(commit "feat: Add a feature")"
	[ "$(cat "${BATS_TMPDIR}/message")" == "🌱 feat: Add a feature" ]

	run ./src/commit-msg "$(commit "fix: Fix a bug")"
	[ "$(cat "${BATS_TMPDIR}/message")" == "🐛 fix: Fix a bug" ]

	run ./src/commit-msg "$(commit "chore: Boring stuff")"
	[ "$(cat "${BATS_TMPDIR}/message")" == "🔧 chore: Boring stuff" ]

	run ./src/commit-msg "$(commit "config: Update config")"
	[ "$(cat "${BATS_TMPDIR}/message")" == "🔩 config: Update config" ]

	run ./src/commit-msg "$(commit "docs: Update readme")"
	[ "$(cat "${BATS_TMPDIR}/message")" == "📖 docs: Update readme" ]
}

# @test "works with multi-line commits" {
# 	run ./src/commit-msg "$(commit "feat: Add a feature\n\nThis is a new feature!")"
# 	[ "$(cat "${BATS_TMPDIR}/message")" == "🌱 feat: Add a feature\n\nThis is a new feature!" ]
# }
