# Day 23 – Git Branching & Working with GitHub

**Date:** 2026-06-23
**Topic:** Branching, GitHub Remotes, Clone vs Fork

---

## Task 1: Understanding Branches

### 1. What is a branch in Git?

A branch is a lightweight, movable pointer to a specific commit. When you create a branch, Git doesn't copy your entire project — it simply creates a new pointer that starts at your current commit and moves forward independently as you make new commits.

Think of the commit history as a timeline. A branch is like a fork in the road — you can go one direction on `main` and a completely different direction on `feature-1`, and the two paths never interfere with each other unless you choose to merge them.

```
main:      A --- B --- C
                        \
feature-1:               D --- E
```

---

### 2. Why do we use branches instead of committing everything to `main`?

Committing everything directly to `main` is risky and messy. Here's why branches matter:

- **Isolation** — You can work on a new feature without breaking working code on `main`
- **Parallel work** — Multiple developers can work on different features simultaneously without conflicts
- **Safe experimentation** — You can try something new, and if it fails, just delete the branch — `main` is untouched
- **Code review** — Teams use branches to create Pull Requests, allowing others to review before merging
- **Rollback** — If a feature branch causes problems, you simply don't merge it

In DevOps, `main` (or `production`) is often protected — only reviewed, tested code gets merged in.

---

### 3. What is `HEAD` in Git?

`HEAD` is a special pointer that always points to **where you currently are** in the repository — usually the tip of your current branch.

When you run `git checkout feature-1`, HEAD moves to point at `feature-1`. Every new commit you make gets attached at HEAD's position, and HEAD advances forward.

```bash
cat .git/HEAD
# → ref: refs/heads/master   (pointing to master branch)
```

If you checkout a specific commit (not a branch), you enter **detached HEAD** state — HEAD points directly to a commit instead of a branch. Any commits you make here won't be tracked by any branch unless you create one.

---

### 4. What happens to your files when you switch branches?

When you run `git switch feature-1`, Git:

1. Reads the snapshot stored in the `feature-1` branch tip commit
2. Updates your working directory files to match that snapshot
3. Moves HEAD to point at `feature-1`

Files that exist on `feature-1` but not on `main` will **appear** in your working directory. Files that exist on `main` but not on `feature-1` will **disappear**. Files that are the same on both branches stay untouched.

⚠️ Important: If you have **uncommitted changes**, Git will warn you and may refuse to switch to protect your work. Always commit or stash before switching branches.

---

## Task 2: Branching Commands — Hands-On

### Commands executed and what happened:

```bash
# 1. List all branches
git branch
# → * master   (only main branch exists)

# 2. Create feature-1
git branch feature-1

# 3. Switch to feature-1
git checkout feature-1
# → Switched to branch 'feature-1'

# 4. Create AND switch to feature-2 in one command
git checkout -b feature-2
# → Switched to a new branch 'feature-2'

# 5. Switch using git switch (modern way)
git switch feature-1
# → Switched to branch 'feature-1'

# 6. Make a commit only on feature-1
echo "feature work" > feature-1-experiment.md
git add feature-1-experiment.md
git commit -m "Add feature-1 experiment file (branch-only commit)"

# 7. Switch back to master — file disappears!
git switch master
ls
# → day-22-notes.md  git-commands.md   (feature-1-experiment.md is GONE)

# 8. Delete feature-2
git branch -d feature-2
# → Deleted branch feature-2
```

### `git switch` vs `git checkout` — What's the difference?

| | `git checkout` | `git switch` |
|---|---|---|
| Purpose | Originally did everything: switch branches, restore files, detach HEAD | Designed only for switching branches |
| Introduced | Original Git | Git 2.23 (2019) |
| Clarity | Confusing — one command does too many things | Clear — only for branch navigation |
| Recommendation | Works everywhere, but legacy | Preferred for branch switching going forward |

`git checkout` can also restore files (`git checkout -- file.txt`), which caused confusion. Git split it into `git switch` (branches) and `git restore` (files) to be more explicit.

---

## Task 3: Push to GitHub

### Steps to connect and push:

```bash
# 1. Create a new repo on GitHub (empty, no README)

# 2. Connect local repo to GitHub remote
git remote add origin https://github.com/YOUR_USERNAME/devops-git-practice.git

# 3. Verify the remote was added
git remote -v
# → origin  https://github.com/YOUR_USERNAME/devops-git-practice.git (fetch)
# → origin  https://github.com/YOUR_USERNAME/devops-git-practice.git (push)

# 4. Push main branch (-u sets upstream tracking for future git push/pull)
git push -u origin master

# 5. Push feature-1 branch
git push origin feature-1
```

After pushing, both branches are visible in GitHub under the **branches** dropdown.

---

### What is the difference between `origin` and `upstream`?

| Term | What it refers to | When you use it |
|------|-------------------|-----------------|
| `origin` | Your own remote repository (your fork or your repo on GitHub) | Default remote name; where YOU push your work |
| `upstream` | The original repository you forked FROM | Used to pull in new changes from the source project |

**Real-world flow:**

```
[Original Repo] ←── upstream ───┐
       │                         │
       ↓ (fork)                  │ (sync)
[Your Fork on GitHub] ←── origin ──── [Your Local Machine]
```

```bash
# Add upstream (after forking someone else's repo)
git remote add upstream https://github.com/ORIGINAL_OWNER/repo.git

# Sync your fork with the original
git fetch upstream
git merge upstream/main
```

---

## Task 4: Pull from GitHub

### What is the difference between `git fetch` and `git pull`?

Both download changes from the remote, but they behave very differently:

**`git fetch`:**
- Downloads all changes from the remote into your local `.git/` database
- Does NOT touch your working directory or current branch
- Safe to run anytime — nothing breaks
- Lets you review changes before applying: `git log origin/main`

**`git pull`:**
- Runs `git fetch` + `git merge` in a single step
- Immediately merges the downloaded changes into your current branch
- Can cause merge conflicts if your local branch has diverged

```bash
# See what changed remotely before merging
git fetch origin
git log HEAD..origin/main --oneline   # see incoming commits

# Then merge when ready
git merge origin/main

# OR do it all at once (less control)
git pull
```

**Rule of thumb:** Use `git fetch` when you want to check what changed first. Use `git pull` when you're confident and want to sync quickly.

---

## Task 5: Clone vs Fork

### Clone a public repo:
```bash
git clone https://github.com/git/git.git
# Downloads the entire repo to your local machine
```

### Fork then clone:
```bash
# 1. Fork on GitHub (click Fork button on the repo page)
# 2. Clone YOUR fork
git clone https://github.com/YOUR_USERNAME/git.git
# 3. Add upstream to stay in sync
git remote add upstream https://github.com/git/git.git
```

---

### What is the difference between clone and fork?

| | Clone | Fork |
|---|---|---|
| What it is | A Git operation — copies a repo to your local machine | A GitHub concept — copies a repo to your GitHub account |
| Where it lives | On your local machine | On GitHub (your account) |
| Connection | Linked to whatever remote you cloned from | Linked to the original repo via upstream |
| Can you push? | Only if you have write access to the original | Yes — it's your own copy on GitHub |

---

### When would you clone vs fork?

**Clone when:**
- It's your own repo (or your team's) and you have push access
- You just want a local copy to read, build, or run
- You're not planning to contribute back

**Fork when:**
- You want to contribute to an open-source project you don't own
- You want your own copy on GitHub to freely experiment with
- You plan to submit a Pull Request to the original repo

---

### After forking, how do you keep your fork in sync with the original repo?

```bash
# Step 1: Add the original repo as upstream (one-time setup)
git remote add upstream https://github.com/ORIGINAL_OWNER/repo.git

# Step 2: Fetch latest changes from the original
git fetch upstream

# Step 3: Switch to your main branch
git switch main

# Step 4: Merge upstream changes into your main
git merge upstream/main

# Step 5: Push updated main to your fork on GitHub
git push origin main
```

This keeps your fork's `main` branch in sync without losing your own work on feature branches.

---

## Commit History After Day 23 (git log --oneline)

```
e153e05 Day 23: Add advanced branching and GitHub remote commands
c4da1ec Add day-22-notes.md with conceptual answers and workflow summary
4bd488c Add Remote Repositories section covering push, pull, clone, and fetch
c9804a5 Add Branching section with branch creation and merge commands
c629be5 Add Undoing Changes section to git-commands reference
2846c07 Add initial git-commands.md with setup, workflow, and viewing commands
```

---

## Key Takeaways from Day 23

1. **Branches are cheap** — creating one takes milliseconds and costs almost no disk space
2. **`main` is sacred** — always work on a feature branch and merge in
3. **`git switch` is the modern way** — use it instead of `git checkout` for branch navigation
4. **`origin` = yours, `upstream` = theirs** — essential for open-source contribution
5. **`git fetch` before `git pull`** — always know what you're pulling in before you merge
6. **Fork = GitHub copy, Clone = local copy** — they solve different problems

---

*Part of my 100 Days of DevOps journey.*