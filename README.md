<div align="center"><img src="./docs/banner.png" width="380" alt="A drawing of a grappling hook, with the word “git-grapnel” under it."></div>
<p>&nbsp;</p>

This is a collection of git hooks I use every day, written in Bash. These aren't
meant to be used as-is, but rather as examples for you own hooks. Each script is
linted with [shellcheck](https://github.com/koalaman/shellcheck) and tested with
[bats](https://github.com/bats-core/bats-core).

## Hooks

### `commit-msg`
TODO

### `post-merge`
TODO

### `pre-commit`
TODO

### `pre-push`
TODO

## Installing a hook

### Copying the script
The simplest way to install a hook script is to copy it in the `hooks` directory
located inside the `.git` folder of your repo. Note that you will need to remove
the extension for `git` to pick it up.

### Using a link
If  you want  to reuse  your scripts  in several  repos, soft  links are  a good
solution, e.g.:
```text
ln -s -T </path/to/script.sh> </path/to/repo>/.git/hooks/commit-msg
```

Here's an  example of a  script to automatically update  the hooks of  every git
repo under `~`, using [fd](https://github.com/sharkdp/fd):
```bash
for gitfolder in $(fd -H -t d '^.git$' "${HOME}"); do
	rm -r "${gitfolder}/hooks"/* &> /dev/null

	for hook in /path/to/hooks/folder/*.sh; do
		ln -sf -T "${hook}" "${gitfolder}/hooks/$(basename "${hook}" .sh)"
	done
done
```

### Add a hook to every new git repo
TODO
