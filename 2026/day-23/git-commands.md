# Git Commands Reference

> My personal Git cheatsheet — updated daily as I learn new commands.

---

## Setup & Config

| Command | What it does | Example |
|--------|-------------|---------|
| `git config --global user.name "Name"` | Sets your name for all commits globally | `git config --global user.name "Jane Doe"` |
| `git config --global user.email "email"` | Sets your email for all commits globally | `git config --global user.email "jane@example.com"` |
| `git config --list` | Shows all current Git configuration values | `git config --list` |
| `git init` | Initializes a new empty Git repository in the current folder | `git init` |

---

## Basic Workflow

| Command | What it does | Example |
|--------|-------------|---------|
| `git status` | Shows the state of the working directory and staging area | `git status` |
| `git add <file>` | Stages a specific file for the next commit | `git add git-commands.md` |
| `git add .` | Stages all changed files in the current directory | `git add .` |
| `git commit -m "message"` | Records staged changes to the repository with a message | `git commit -m "Add initial git commands reference"` |
| `git diff` | Shows unstaged changes between working directory and last commit | `git diff` |
| `git diff --staged` | Shows staged changes that are ready to be committed | `git diff --staged` |

---

## Viewing Changes

| Command | What it does | Example |
|--------|-------------|---------|
| `git log` | Shows full commit history with author, date, and message | `git log` |
| `git log --oneline` | Shows compact one-line-per-commit history | `git log --oneline` |
| `git log --oneline --graph` | Shows history as an ASCII branch graph | `git log --oneline --graph` |
| `git show <commit>` | Shows details and diff of a specific commit | `git show a1b2c3d` |

---

## Undoing Changes

| Command | What it does | Example |
|--------|-------------|---------|
| `git restore <file>` | Discards unstaged changes in working directory | `git restore index.html` |
| `git restore --staged <file>` | Unstages a file (removes from staging area, keeps changes) | `git restore --staged notes.md` |
| `git commit --amend` | Modifies the most recent commit (message or content) | `git commit --amend -m "Fixed typo in message"` |

---

## Branching

| Command | What it does | Example |
|--------|-------------|---------|
| `git branch` | Lists all local branches | `git branch` |
| `git branch <name>` | Creates a new branch | `git branch feature/login` |
| `git checkout <branch>` | Switches to an existing branch | `git checkout feature/login` |
| `git checkout -b <name>` | Creates and immediately switches to a new branch | `git checkout -b hotfix/bug-42` |
| `git merge <branch>` | Merges specified branch into the current branch | `git merge feature/login` |

---

## Remote Repositories

| Command | What it does | Example |
|--------|-------------|---------|
| `git remote add origin <url>` | Links local repo to a remote repository | `git remote add origin https://github.com/user/repo.git` |
| `git remote -v` | Lists all configured remote connections | `git remote -v` |
| `git push origin <branch>` | Uploads local branch commits to the remote | `git push origin main` |
| `git pull` | Fetches and merges changes from the remote | `git pull` |
| `git clone <url>` | Copies a remote repository to your local machine | `git clone https://github.com/user/repo.git` |
| `git fetch` | Downloads changes from remote without merging | `git fetch origin` |

---

## Branching — Advanced

| Command | What it does | Example |
|--------|-------------|---------|
| `git branch` | Lists all local branches (current branch marked with *) | `git branch` |
| `git branch <name>` | Creates a new branch from the current HEAD | `git branch feature-1` |
| `git checkout <branch>` | Switches to an existing branch | `git checkout feature-1` |
| `git checkout -b <name>` | Creates a new branch and switches to it immediately | `git checkout -b feature-2` |
| `git switch <branch>` | Modern way to switch branches (cleaner than checkout) | `git switch feature-1` |
| `git switch -c <name>` | Modern way to create and switch to a new branch | `git switch -c hotfix/bug-99` |
| `git branch -d <name>` | Deletes a branch (safe — won't delete unmerged work) | `git branch -d feature-2` |
| `git branch -D <name>` | Force-deletes a branch (even if unmerged) | `git branch -D experimental` |
| `git merge <branch>` | Merges a branch into your current branch | `git merge feature-1` |
| `git log --oneline --graph --all` | Shows full branch history as an ASCII graph | `git log --oneline --graph --all` |

---

## GitHub & Remotes — Advanced

| Command | What it does | Example |
|--------|-------------|---------|
| `git remote add origin <url>` | Links local repo to a GitHub remote called origin | `git remote add origin https://github.com/user/repo.git` |
| `git remote -v` | Lists all remote connections with their URLs | `git remote -v` |
| `git push -u origin <branch>` | Pushes branch to GitHub and sets upstream tracking | `git push -u origin main` |
| `git push origin <branch>` | Pushes an existing tracked branch to GitHub | `git push origin feature-1` |
| `git fetch` | Downloads changes from remote but does NOT merge | `git fetch origin` |
| `git pull` | Fetches AND merges remote changes into current branch | `git pull` |
| `git clone <url>` | Copies an entire remote repo to your local machine | `git clone https://github.com/user/repo.git` |
| `git remote add upstream <url>` | Adds the original repo as upstream (used after forking) | `git remote add upstream https://github.com/original/repo.git` |