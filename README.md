<img src="/docs/banner.png" width="380" align="center" alt="A drawing of a grappling hook, with the word “git-grapnel” under it."></div>

![License](https://badgen.net/github/license/cheap-glitch/git-grapnel?color=green)
![Latest release](https://badgen.net/github/release/cheap-glitch/git-grapnel?color=green)

This is a collection of custom [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

## Features

 * Automatically lint any modified files before committing
 * Smart spellchecking of commit messages
 * Can enforce the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0) specification
 * …and more!

> Note: even thought  these scripts can be configured to  a certain degree, they
> can't  possibly cover  all existing  use  cases, and  thus are  meant more  as
> blueprints and sources of inspiration rather than comprehensive solutions.

## Installation

First, [download the  scripts](https://github.com/cheap-glitch/git-grapnel/releases/latest)
and make them executable (`chmod +x <scripts>`).

### For a single git repo

Place the scripts in a folder named  `hooks` inside the `.git` directory of that
repo.

### For every git repo

Ensure the scripts are in your `PATH` so that `git` can execute them.

Then  point the  `core.hooksPath` config  option  to the  folder containing  the
scripts, e.g. if they're stored in `~/.git-grapnel`:

```shell
git config core.hooksPath ~/.git-grapnel
```

### External dependencies

Some of the scripts  use external tools to accomplish their  tasks, so make sure
you install them too:
 * [jq](https://stedolan.github.io/jq) to parse JSON data
 * [aspell](http://aspell.net) to spellcheck commit messages

## Usage

Each  of  the  hooks can  be  bypassed  by  calling  its git  command  with  the
`--no-verify` option.

All  the features  are disabled  by  default, and  each  on can  be enabled  and
configured by setting some environment variables (`GIT_GRAPNEL_*`).

### [pre-commit](https://github.com/cheap-glitch/git-grapnel/blob/main/src/pre-commit)

This hook is run whenever committing to a repo.

Setting `GIT_GRAPNEL_LINT_ON_COMMIT` to `1` will enable the automatic linting of
modified source  files. The commit will  be cancelled if any  errors or warnings
are produced.

### [commit-msg](https://github.com/cheap-glitch/git-grapnel/blob/main/src/commit-msg)

This hook is run whenever committing to a repo.

Setting  `GIT_GRAPNEL_COMMIT_MSG_FORMAT` to  one  of the  following values  will
enforce that particular format for commit message:
 * `basic`: the message must start with a capital letter and not end with a full stop
 * `conventional-commits`: the message must conform to the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0) specification

It can also:
 * spellcheck the commit message and highlight possible typos (`GIT_GRAPNEL_SPELLCHECK`)
 * convert  pairs of  single  quotes (`''`) into  a single  back quote — useful when you
   surround the message in double quotes on the command line (`GIT_GRAPNEL_CONVERT_SINGLE_QUOTE_PAIRS`)
 * automatically add a corresponding emoji at the start of Conventional Commits messages (`GIT_GRAPNEL_ADD_EMOJIS`)

### [pre-push](https://github.com/cheap-glitch/git-grapnel/blob/main/src/pre-push)

This hook is run whenever pushing to a remote.

Setting  `GIT_GRAPNEL_PRE_PUSH_CHECKS`  to  `1`   will  automatically  lint  the
codebase and  run the testing scripts  present in `package.json`, and  abort the
push if any of them fail.

### [post-merge](https://github.com/cheap-glitch/git-grapnel/blob/main/src/post-merge)

This hook is run after a successful merge.

Setting `GIT_GRAPNEL_AUTO_INSTALL`  to `1`  will reinstall  the Node  modules as
needed to keep them in sync with `package-lock.json`.

## Contributing

Contributions are welcomed! Please open an issue before submitting substantial changes.

## Related

 * [Pro Git, 8.3 Customizing Git - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - More infos on git hooks
 * [git-toolbelt](https://github.com/nvie/git-toolbelt) - A collection of convenient utilities for everyday git usage

## License

ISC
