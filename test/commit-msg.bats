#!/usr/bin/env bats
# shellcheck disable=SC2016,SC2030,SC2031

TEST_DIR="$(dirname "${BATS_TEST_FILENAME:-}")"
COMMIT_MSG_FILE="${BATS_SUITE_TMPDIR:-}/commit-message"

setup() {
	load ../node_modules/bats-support/load.bash
	load ../node_modules/bats-assert/load.bash

	PATH="${PATH}:${TEST_DIR}/../src"

	export GIT_GRAPNEL_ADD_EMOJIS=0
	export GIT_GRAPNEL_SPELLCHECK=0
	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=none
	export GIT_GRAPNEL_CONVERT_SINGLE_QUOTE_PAIRS=0
}

commit() {
	echo "${1}" >"${COMMIT_MSG_FILE}"
	echo "${COMMIT_MSG_FILE}"
}

@test "valid commit messages don't trigger an error" { # {{{

	run commit-msg "$(commit "add a new feature")"
	assert_success

	run commit-msg "$(commit "style: format the code base")"
	assert_success

	run commit-msg "$(commit "chore: Update dependencies.")"
	assert_success

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=basic

	run commit-msg "$(commit "Add a new feature")"
	assert_success

	run commit-msg "$(commit "Fix a nasty bug")"
	assert_success

	run commit-msg "$(commit "Meta: Update documentation")"
	assert_success

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits

	run commit-msg "$(commit "feat: Add a feature")"
	assert_success

	run commit-msg "$(commit "test: Improve the tests")"
	assert_success

	run commit-msg "$(commit "fix: Fix a bug")"
	assert_success

	run commit-msg "$(commit "feat(parser): Add a feature in the parser")"
	assert_success

	run commit-msg "$(commit "refactor!: Create a breaking change")"
	assert_success

	run commit-msg "$(commit "revert!(core): Another breaking change")"
	assert_success

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits GIT_GRAPNEL_ADD_EMOJIS=1

	run commit-msg "$(commit "🌱 feat: Add a feature")"
	assert_success

	run commit-msg "$(commit "📖 docs: Update readme")"
	assert_success

	run commit-msg "$(commit "♻️  refactor: Rename all functions")"
	assert_success

} # }}}

@test "incorrectly formatted commit messages trigger an error" { # {{{

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=basic

	run commit-msg "$(commit "add a new feature")"
	assert_failure

	run commit-msg "$(commit "Fix a nasty bug.")"
	assert_failure

	run commit-msg "$(commit "meta: update documentation")"
	assert_failure

	run commit-msg "$(commit "Meta: update documentation")"
	assert_failure

	run commit-msg "$(commit "Meta : Update documentation")"
	assert_failure

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits

	run commit-msg "$(commit "feat Add a new feature")"
	assert_failure

	run commit-msg "$(commit "docs:Update readme")"
	assert_failure

	run commit-msg "$(commit "style: format the code base")"
	assert_failure

	run commit-msg "$(commit "fix(core: Fix a bug")"
	assert_failure

	run commit-msg "$(commit "chore: Update dependencies.")"
	assert_failure

} # }}}

@test "incorrect Conventional Commits types trigger an error" { # {{{

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits

	run commit-msg "$(commit "bug: Fix a bug")"
	assert_failure

	run commit-msg "$(commit "ref: Refactor main module")"
	assert_failure

} # }}}

@test "emojis are automatically added before the commit type" { # {{{

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits GIT_GRAPNEL_ADD_EMOJIS=1

	commit-msg "$(commit "feat: Add a feature")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "🌱 feat: Add a feature"

	commit-msg "$(commit "🌱 feat: Add a feature")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "🌱 feat: Add a feature"

	commit-msg "$(commit "fix: Fix a bug")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "🐛 fix: Fix a bug"

	commit-msg "$(commit "chore: Boring stuff")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "🔧 chore: Boring stuff"

	commit-msg "$(commit "config: Update config")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "🔩 config: Update config"

	commit-msg "$(commit "docs: Update readme")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "📖 docs: Update readme"

	commit-msg "$(commit "$(echo -e "feat: Add a feature\n\nThis is a new feature.")")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "$(echo -e "🌱 feat: Add a feature\n\nThis is a new feature.")"

	commit-msg "$(commit "$(echo -e "feat: Add a feature\n\nThis is a new feature.\n\nMore infos here.")")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "$(echo -e "🌱 feat: Add a feature\n\nThis is a new feature.\n\nMore infos here.")"

} # }}}

@test "spelling mistakes trigger an error" { # {{{

	run commit-msg "$(commit "Spelling miskates are ignord by defaut")"
	assert_success

	export GIT_GRAPNEL_SPELLCHECK=1

	run commit-msg "$(commit "No spelling mistakes here")"
	assert_success

	run commit-msg "$(commit "We all make mitsakes")" <<< 'n'
	assert_failure
	assert_output --partial "Some spelling mistakes were detected"

	run commit-msg "$(commit "Ignoring a posible typo")" <<< 'y'
	assert_success

	run commit-msg "$(commit "Typos shoulld be highligted")" <<< 'n'
	assert_failure
	assert_output --partial "$(echo -e "Typos \e[31mshoulld\e[0m be \e[31mhighligted\e[0m")"

	run commit-msg "$(commit 'Typos inside backquotes should be ignored: `foo` `bar` `camel-case-msg`')"
	assert_success

} # }}}

@test "pairs of single quotes are converted to backquotes" { # {{{

	commit-msg "$(commit "Change ''foo'' to ''bar''")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "Change ''foo'' to ''bar''"

	export GIT_GRAPNEL_CONVERT_SINGLE_QUOTE_PAIRS=1

	commit-msg "$(commit "Change ''foo'' to ''bar''")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" 'Change `foo` to `bar`'

	commit-msg "$(commit "Don't touch other single quotes")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" "Don't touch other single quotes"

	export GIT_GRAPNEL_COMMIT_MSG_FORMAT=conventional-commits

	commit-msg "$(commit "chore: Change ''foo'' to ''bar''")"
	assert_equal "$(cat "${COMMIT_MSG_FILE}")" 'chore: Change `foo` to `bar`'

} # }}}
