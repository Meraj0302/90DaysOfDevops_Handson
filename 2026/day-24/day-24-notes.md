# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry-Pick

**Date:** 2026-06-23
**Topic:** Merge strategies, Rebase, Stash, Cherry-pick

---

## Task 1: Git Merge — Hands-On

### Commands run:

```bash
# Fast-forward merge
git checkout -b feature-login
# ... made 2 commits ...
git switch master
git merge feature-login
# → Fast-forward (no merge commit)

# Merge commit (diverged branches)
git checkout -b feature-signup
# ... made 2 commits on feature-signup ...
git switch master
echo "hotfix" >> README-update.md && git commit -m "docs: update readme"
git merge feature-signup
# → Merge made by the 'ort' strategy (merge commit created)

# Intentional merge conflict
git checkout -b feature-conflict-a
sed -i 's/Add login form/BRANCH-A: redesigned login form/' login.md
git commit -am "feat: branch-A changes login form text"

git switch master
sed -i 's/Add login form/MASTER: updated login form description/' login.md
git commit -am "feat: master also changed login form text"

git merge feature-conflict-a
# CONFLICT (content): Merge conflict in login.md
```

**The conflict marker Git inserted in login.md:**
```
<<<<<<< HEAD
- MASTER: updated login form description
=======
- BRANCH-A: redesigned login form
>>>>>>> feature-conflict-a
```

**Resolution:** manually removed the conflict markers, kept the master version, then:
```bash
git add login.md
git commit -m "fix: resolve merge conflict in login.md"
```

---

### What is a fast-forward merge?

A fast-forward merge happens when the branch you're merging **has no competing history** — master hasn't moved at all since the feature branch was created. Git simply moves the `main` pointer forward to the tip of the feature branch. No new commit is created.

```
Before:           After (fast-forward):
main: A─B         main: A─B─C─D
           \                 ↑
feature:  C─D       (feature-login pointer)
```

You can tell it happened because Git says `Fast-forward` in the output, not `Merge made by the 'ort' strategy`.

---

### When does Git create a merge commit instead?

Git creates a merge commit when **both branches have diverged** — meaning `main` has received new commits since the feature branch was created. There are two separate lines of history that need to be joined together, so Git creates a new "tie" commit with two parents.

```
Before:             After (merge commit):
main:   A─B─C           A─B─C─────M
                \             \  /
feature: D─E─F        D─E─F─/
```

The merge commit `M` has two parents: `C` (from main) and `F` (from feature).

---

### What is a merge conflict? How to create one intentionally.

A merge conflict happens when **the same line(s) in the same file were edited differently on two branches** that you're trying to merge. Git doesn't know which version to keep, so it pauses and asks you to decide.

**How to create one intentionally:**
1. Edit line 2 of `login.md` on `feature-conflict-a`
2. Edit the same line 2 of `login.md` on `master`
3. `git merge feature-conflict-a` → conflict

Git marks the conflicting section with `<<<<<<<`, `=======`, and `>>>>>>>`. You manually edit the file to resolve it, then `git add` and `git commit`.

**Rule:** Always read both versions carefully before resolving — don't just delete one blindly.

---

## Task 2: Git Rebase — Hands-On

### Commands run:

```bash
git checkout -b feature-dashboard
# ... 3 commits on feature-dashboard ...

git switch master
echo "hotfix" >> hotfix-note.md && git commit -m "fix: apply hotfix on master"
# master is now 1 commit ahead of where feature-dashboard branched

git switch feature-dashboard
git rebase master
# Rewinding and replaying 3 commits on top of master's new commit
```

### History BEFORE rebase:
```
* 6959000 feat: add stats panel          ← feature-dashboard
* e14288e feat: add chart component
* b8bc0f7 feat: add dashboard widget layout
| * 7beb66e fix: apply hotfix on master  ← master
|/
* ea646f3 ...
```

### History AFTER rebase (linear!):
```
* d925749 feat: add stats panel          ← feature-dashboard (new hashes!)
* e568025 feat: add chart component
* 9eac0b4 feat: add dashboard widget layout
* 7beb66e fix: apply hotfix on master    ← master
* ea646f3 ...
```

---

### What does rebase actually do to your commits?

Rebase **replays your commits one by one on top of another branch**. It doesn't just move a pointer — it literally creates **brand new commits** with new SHA hashes. The content is the same but the parent is different.

Think of it like this: imagine your 3 commits are written on sticky notes. Rebase peels them off from where they were, then re-sticks them on top of master's latest commit. New position, same content — but technically new commits.

---

### How is the history different from a merge?

| | Merge | Rebase |
|---|---|---|
| History shape | Preserves the fork — you see diverging and rejoining lines | Always linear — looks like work happened sequentially |
| Merge commit | Creates one (when branches diverged) | No merge commit |
| Commit hashes | Original hashes preserved | New hashes created |
| Honesty | Shows the true history of when things happened | Rewrites history to look cleaner |

---

### Why should you NEVER rebase commits that have been pushed and shared?

When you rebase, Git **rewrites commit hashes**. If you've already pushed those commits to GitHub and your teammate has pulled them, they now have the original hashes in their history. If you force-push the rebased version, their history diverges from yours — and the next `git pull` becomes a disaster of duplicated commits and conflicts.

**Golden rule of rebase:** Only rebase commits that exist only on your local machine and have never been pushed to a shared remote.

---

### When to use rebase vs merge?

| Use **merge** when... | Use **rebase** when... |
|---|---|
| Merging a feature branch into `main` | Updating a feature branch with latest `main` changes |
| You want to preserve the exact history | You want a clean, linear history before merging |
| The branch was shared with others | The branch is local/personal only |
| Working in a team with shared history | Preparing a PR to look clean before review |

---

## Task 3: Squash Merge vs Regular Merge

### Commands run:

```bash
# feature-profile: 5 messy WIP commits
git checkout -b feature-profile
# 5 commits: wip, wip, fix typo, wip, style...

# Squash merge
git switch master
git merge --squash feature-profile
git commit -m "feat: add complete profile page (squashed 5 commits)"
# → Only 1 commit appears on master

# Regular merge (feature-settings, few commits, no squash)
git checkout -b feature-settings
# a few commits...
git switch master
git merge feature-settings
# → All individual commits appear on master history
```

---

### What does squash merging do?

`git merge --squash` takes ALL the commits from the feature branch and **combines them into a single staged change** in your working directory — but doesn't create the commit automatically. You then write one clean, meaningful commit message.

The result: your `main` branch gets one tidy commit instead of 5 messy "wip", "fix typo", "formatting" commits.

---

### When to use squash merge vs regular merge?

**Use squash when:**
- The feature branch has lots of messy WIP/fix-typo commits
- You want `main`'s history to stay clean and readable
- Each feature should be one logical unit in the history

**Use regular merge when:**
- Each commit in the feature branch is meaningful and worth preserving
- You want the full story of how the feature was built
- You're working on a large feature with clear sub-commits

---

### What is the trade-off of squashing?

You lose the granular history. If a bug is introduced somewhere in those 5 commits, you can no longer pinpoint exactly which micro-change caused it — because they all became one. The feature branch itself still has the full history, but once it's deleted, that detail is gone.

**Rule of thumb:** Squash when the journey is messy and only the destination matters. Keep individual commits when the journey itself has value.

---

## Task 4: Git Stash — Hands-On

### Commands run:

```bash
# Start changes, don't commit
echo "work in progress" > wip-feature.md
git add wip-feature.md

# Try to switch — Git warns (or carries changes along)
git switch feature-dashboard  # might warn about uncommitted changes

# Stash with a label
git stash push -m "WIP: half-finished wip-feature changes"
# → Saved working directory and index state

# Switch freely now
git switch feature-dashboard
# ... do work ...
git switch master

# Apply and remove stash
git stash pop
# → wip-feature.md is back, exactly as left

# Multiple stashes
git stash push -m "stash: item one"
git stash push -m "stash: item two"
git stash push -m "stash: item three"

git stash list
# stash@{0}: On master: stash: item three
# stash@{1}: On master: stash: item two
# stash@{2}: On master: stash: item one

# Apply a specific stash without removing it
git stash apply stash@{1}

# Pop removes the top stash after applying
git stash pop
```

---

### What is the difference between `git stash pop` and `git stash apply`?

| | `git stash pop` | `git stash apply` |
|---|---|---|
| Applies the stash? | ✅ Yes | ✅ Yes |
| Removes from stash list? | ✅ Yes (stash is gone after) | ❌ No (stash stays in list) |
| When to use | You're done with the stash — apply and discard | You want to apply the same stash to multiple branches, or just aren't sure yet |

---

### When would you use stash in a real-world workflow?

1. **Urgent context switch** — You're halfway through a feature when a production bug comes in. Stash your work, fix the bug on a hotfix branch, then pop your stash and continue.
2. **Wrong branch** — You started coding on `main` by accident. Stash, switch to the right branch, pop.
3. **Pulling latest changes** — Your working tree is dirty and `git pull` would conflict. Stash, pull, pop, resolve any conflicts.
4. **Testing someone else's branch** — Stash your work, checkout their branch, test it, come back and pop.

---

## Task 5: Cherry-Pick — Hands-On

### Commands run:

```bash
git checkout -b feature-hotfix

git commit -m "fix: security patch for auth module"       # commit 1
git commit -m "fix: critical null pointer in payment flow" # commit 2 ← want this
git commit -m "chore: remove unused imports"               # commit 3

git log --oneline
# bfc08de chore: remove unused imports
# cf91a23 fix: critical null pointer in payment flow
# fdb80c3 fix: security patch for auth module

git switch master
git cherry-pick cf91a23
# [master 1ae25a2] fix: critical null pointer in payment flow

git log --oneline -3
# 1ae25a2 fix: critical null pointer in payment flow  ← only this one
# 412b1da feat: add complete profile page
# 7beb66e fix: apply hotfix on master
```

`hotfix-b.md` is present on master. `hotfix-a.md` and `hotfix-c.md` are NOT.

---

### What does cherry-pick do?

Cherry-pick takes a **single specific commit** from any branch and applies its changes onto your current branch as a brand new commit. The new commit has different SHA hash but identical content to the original.

It's surgical — instead of merging an entire branch (which brings all its commits), you pick exactly one commit you need.

---

### When would you use cherry-pick in a real project?

1. **Hotfix to multiple branches** — A critical bug is fixed on `develop`. You need that fix on `main` (production) right now, without merging all of develop.
2. **Rescue a commit** — You accidentally committed something to the wrong branch. Cherry-pick it to the right branch, then revert or remove from the wrong one.
3. **Selective feature backport** — A new feature was built for v3, but one small utility function is needed in the v2 branch too.
4. **Undo a partial merge** — A feature branch had 10 commits, but only 2 are actually ready for production.

---

### What can go wrong with cherry-picking?

1. **Duplicate commits** — If you cherry-pick a commit then later merge the whole branch, you get the same change twice in history (with different hashes). This causes confusion and potential conflicts.

2. **Dependency on other commits** — A cherry-picked commit might depend on code introduced in a previous commit on that branch. If you don't bring that dependency along, the code breaks.

3. **Diverging histories** — Heavy cherry-picking across branches makes the commit graph hard to follow. Team members lose track of what's where.

4. **Conflict** — The same file may have changed differently on both branches, causing a conflict during cherry-pick just like a merge.

**Rule:** Use cherry-pick sparingly. If you find yourself doing it often, it's usually a sign the branching strategy needs rethinking.

---

## Final git log --oneline (master)

```
3326689 Day 24: Add merge, rebase, stash, and cherry-pick commands
1ae25a2 fix: critical null pointer in payment flow
412b1da feat: add complete profile page (squashed 5 commits)
7beb66e fix: apply hotfix on master
ea646f3 fix: resolve merge conflict in login.md — kept master description
3f1a391 feat: master also changed login form text
1128130 Merge branch 'feature-signup'
4256c3c docs: update readme on master
a7e21fc feat: add password validation
be49342 feat: add login form skeleton
fad406a Add day-23-notes.md with branching, GitHub, clone vs fork answers
e153e05 Day 23: Add advanced branching and GitHub remote commands
```

---

## Key Takeaways from Day 24

1. **Fast-forward = no history fork ever existed** — Git just slides the pointer forward
2. **Merge commit = honesty** — it records that two separate lines of work were joined
3. **Rebase = rewrite history to be linear** — cleaner, but never do it on shared/pushed commits
4. **Squash before merging** — keeps `main` readable when your feature branch is full of WIP commits
5. **Stash = a clipboard for your work** — save it, context-switch, come back
6. **Cherry-pick = surgical strike** — one commit, applied anywhere, use sparingly

---

*Part of my 100 Days of DevOps journey.*