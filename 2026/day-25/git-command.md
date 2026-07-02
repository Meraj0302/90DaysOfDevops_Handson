# Git Commands Reference (Days 22–25)

## Setup & Config

```bash
git init                              # initialize a new repo
git clone <url>                       # clone a remote repo
git config --global user.name "..."   # set your name
git config --global user.email "..."  # set your email
git config --list                     # view all config
git config --global init.defaultBranch main   # set default branch name
git config --global core.editor "code --wait" # set default editor
```

## Basic Workflow

```bash
git status                # see staged/unstaged/untracked changes
git status -s              # short/compact status output

git add <file>             # stage a specific file
git add .                  # stage all changes in current dir
git add -p                 # interactively stage hunks

git commit -m "message"           # commit staged changes
git commit -am "message"          # stage tracked file changes + commit (skips new files)
git commit --amend                # edit the last commit (message and/or contents)

git log                    # full commit history
git log --oneline          # compact one-line-per-commit history
git log --oneline --graph --all   # visual branch graph
git log -p                 # show diffs per commit

git diff                   # unstaged changes vs last commit
git diff --cached          # staged changes vs last commit
git diff <commitA> <commitB>      # diff between two commits
```

## Branching

```bash
git branch                 # list local branches
git branch <name>          # create a new branch
git branch -d <name>       # delete a merged branch
git branch -D <name>       # force-delete an unmerged branch

git checkout <branch>      # switch to a branch
git checkout -b <branch>   # create + switch in one step

git switch <branch>        # modern way to switch branches
git switch -c <branch>     # modern way to create + switch
```

## Remote

```bash
git remote -v                      # list remotes
git remote add origin <url>        # add a remote
git remote remove <name>           # remove a remote

git push origin <branch>           # push branch to remote
git push -u origin <branch>        # push + set upstream tracking
git push --force-with-lease        # safer force-push (checks for others' work)

git pull                           # fetch + merge from tracked remote branch
git pull --rebase                  # fetch + rebase instead of merge

git fetch                          # download remote changes without merging
git fetch --all                    # fetch from all remotes

git clone <url>                    # copy a repo locally
# "fork" = a GitHub-side copy of someone else's repo into your account (not a git CLI command)
```

## Merging & Rebasing

```bash
git merge <branch>                 # merge another branch into current branch
git merge --no-ff <branch>         # force a merge commit even if fast-forward possible
git merge --abort                  # abort a merge with conflicts

git rebase <branch>                # replay current branch's commits on top of <branch>
git rebase -i HEAD~3                # interactive rebase: squash/reword/reorder last 3 commits
git rebase --continue               # continue after resolving a rebase conflict
git rebase --abort                  # cancel an in-progress rebase
```

## Stash & Cherry-Pick

```bash
git stash                  # shelve current uncommitted changes
git stash list              # list stashes
git stash pop               # re-apply and remove latest stash
git stash apply              # re-apply latest stash but keep it in the list
git stash drop                # delete a stash without applying
git stash -u                  # also stash untracked files

git cherry-pick <commit-hash>     # apply a specific commit from another branch onto current branch
git cherry-pick <hashA> <hashB>   # cherry-pick multiple commits
git cherry-pick --abort           # abort a cherry-pick with conflicts
```

## Reset & Revert

```bash
git reset --soft HEAD~1     # move HEAD back, keep changes staged
git reset --mixed HEAD~1    # move HEAD back, unstage changes, keep files (default mode)
git reset --hard HEAD~1     # move HEAD back, discard changes from index AND working dir (destructive)
git reset <commit>          # reset to any specific commit

git revert <commit>         # create a new commit that undoes <commit> (history-safe)
git revert --no-edit <commit>  # revert without opening editor for commit message
git revert -n <commit>      # revert but don't auto-commit (lets you batch multiple reverts)

git reflog                  # show full history of HEAD movements — recovery safety net
                             # use with: git reset --hard <hash-from-reflog>
```

### Quick decision guide
- Undo **local, unpushed** commits → `git reset`
- Undo **pushed/shared** commits → `git revert`
- "I think I lost a commit" → `git reflog`