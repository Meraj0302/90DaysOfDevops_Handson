# Day 22 – Git Notes & Reflections

**Date:** 2026-06-20  
**Topic:** Introduction to Git – First Repository

---

## Task Setup Summary

```bash
# Verified Git version
git --version
# → git version 2.x.x

# Configured identity
git config --global user.name "DevOps Learner"
git config --global user.email "devops.learner@example.com"

# Created project and initialized repo
mkdir devops-git-practice
cd devops-git-practice
git init
```

### What's inside `.git/`?

After running `git init`, Git creates a hidden `.git/` directory with this structure:

```
.git/
├── HEAD          # Points to the current branch (e.g., ref: refs/heads/master)
├── config        # Local repo configuration (remotes, user settings)
├── description   # Used by GitWeb — ignore for now
├── branches/     # Legacy directory (mostly unused in modern Git)
├── hooks/        # Scripts that run on Git events (pre-commit, post-merge, etc.)
├── info/         # Contains .gitignore overrides (exclude file)
├── objects/      # The actual database — stores all commits, trees, and blobs
└── refs/         # References to commits (branches and tags live here)
```

---

## Task 6: Conceptual Questions

### 1. What is the difference between `git add` and `git commit`?

`git add` moves changes from your **working directory** into the **staging area** (also called the index). It's like putting items into a box before sealing it.

`git commit` takes everything in the staging area and permanently records it as a snapshot in the **repository history**. It seals the box, labels it, and puts it in the warehouse.

In short:
- `git add` → "I want to include this in my next save"
- `git commit` → "Save this snapshot now, forever"

---

### 2. What does the staging area do? Why doesn't Git just commit directly?

The staging area is a **deliberate middle step** between editing files and saving history. It gives you precise control over *what* goes into each commit.

Without it, a commit would include every unsaved change in your entire project — even half-finished work or unrelated edits. With the staging area, you can:

- Commit only a subset of your changes
- Review exactly what you're about to save (`git diff --staged`)
- Group related changes into a single logical commit, even if you made them at different times

This makes your commit history cleaner, more meaningful, and easier to trace when debugging.

---

### 3. What information does `git log` show you?

`git log` displays the full history of commits in reverse chronological order (newest first). For each commit it shows:

- **Commit hash** — a unique SHA-1 identifier (e.g., `a1b2c3d4...`)
- **Author** — name and email of who made the commit
- **Date** — timestamp of when the commit was made
- **Commit message** — the description written at commit time

Useful variants:
- `git log --oneline` — compact one-line format, great for overview
- `git log --oneline --graph` — adds branch/merge visualization

---

### 4. What is the `.git/` folder and what happens if you delete it?

The `.git/` folder **is** the repository. It contains every commit, every branch, every piece of history, and all configuration for that project.

If you delete `.git/`, your project folder becomes a plain folder — Git completely forgets the entire history. Your current files remain unchanged on disk, but:

- All commits are gone
- All branches are gone
- `git status`, `git log`, and every other Git command will stop working
- You'd need to run `git init` to start fresh (with no history)

**Lesson:** Never delete `.git/` unless you intentionally want to remove a repository.

---

### 5. What is the difference between working directory, staging area, and repository?

These are the three zones Git uses to manage your code:

| Zone | What it is | When you use it |
|------|-----------|----------------|
| **Working Directory** | Your actual files on disk — what you see in your editor | Anytime you're writing/editing code |
| **Staging Area** (Index) | A holding area for changes you've marked for the next commit | After `git add`, before `git commit` |
| **Repository** (`.git/`) | Permanent, compressed history of all your snapshots | After `git commit` — permanent record |

The flow is always: **Working Directory → Staging Area → Repository**

```
[Edit file]  →  git add  →  [Staging Area]  →  git commit  →  [Repository]
```

Changes only move forward through these zones — they never change automatically. You control each step.

---

## Commit History (git log --oneline)

```
4bd488c Add Remote Repositories section covering push, pull, clone, and fetch
c9804a5 Add Branching section with branch creation and merge commands
c629be5 Add Undoing Changes section to git-commands reference
2846c07 Add initial git-commands.md with setup, workflow, and viewing commands
```

---

## Key Takeaways from Day 22

1. Git tracks *changes*, not files — it stores snapshots of your project state
2. The staging area is intentional, not redundant — use it to craft clean commits
3. Every commit should have a **clear, descriptive message** in the imperative tense ("Add feature" not "Added feature")
4. `git status` is your best friend — read it carefully, it tells you exactly what to do next
5. The `.git/` directory is sacred — it IS your repository

---

*This file is part of my 100 Days of DevOps journey.*