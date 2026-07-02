# Day 28 – Revision Day (Day 1 to Day 27)

## Objective

Today was focused on revising everything learned from Day 1 to Day 27. Instead of learning new concepts, I reviewed Linux, Shell Scripting, Git & GitHub, Networking, LVM, GitHub CLI, and my previous hands-on tasks to identify weak areas and strengthen my understanding.

---

# Task 1 – Self Assessment Checklist

## Linux

| Topic | Status |
|--------|--------|
| Navigate file system, create/move/delete files | ✅ Can do confidently |
| Manage processes (ps, top, kill, bg, fg) | ✅ Can do confidently |
| Manage services using systemctl | ✅ Can do confidently |
| Edit files using Vim/Nano | ✅ Can do confidently |
| Troubleshoot CPU, Memory & Disk | ✅ Can do confidently |
| Explain Linux File System Hierarchy | ✅ Can do confidently |
| Create users and groups | ✅ Can do confidently |
| Set permissions using chmod | ✅ Can do confidently |
| Change ownership using chown/chgrp | ✅ Can do confidently |
| Create and manage LVM | 🟡 Need to revisit |
| Network troubleshooting (ping, curl, ss, dig) | ✅ Can do confidently |
| Explain DNS, IP, Subnet, Ports | 🟡 Need to revisit |

---

## Shell Scripting

| Topic | Status |
|--------|--------|
| Variables, arguments, user input | ✅ Can do confidently |
| if/elif/else and case | ✅ Can do confidently |
| for, while, until loops | ✅ Can do confidently |
| Functions | ✅ Can do confidently |
| grep, awk, sed, sort, uniq | 🟡 Need to revisit |
| Error handling (set -euo pipefail, trap) | 🟡 Need to revisit |
| Schedule scripts with crontab | ✅ Can do confidently |

---

## Git & GitHub

| Topic | Status |
|--------|--------|
| Initialize repository | ✅ Can do confidently |
| Branching | ✅ Can do confidently |
| Push & Pull | ✅ Can do confidently |
| Clone vs Fork | ✅ Can do confidently |
| Merge branches | ✅ Can do confidently |
| Rebase | 🟡 Need to revisit |
| Git stash | ✅ Can do confidently |
| Cherry-pick | ✅ Can do confidently |
| Squash merge | 🟡 Need to revisit |
| Reset & Revert | ✅ Can do confidently |
| GitFlow / GitHub Flow / Trunk-Based | 🟡 Need to revisit |
| GitHub CLI | ✅ Can do confidently |

---

# Task 2 – Revisited Weak Topics

## 1. Logical Volume Manager (LVM)

### What I reviewed

- Physical Volume (PV)
- Volume Group (VG)
- Logical Volume (LV)
- Extending logical volumes
- Reducing logical volumes
- Resizing filesystem

### What I learned again

LVM provides flexible disk management. Unlike traditional partitions, it allows storage to be expanded without repartitioning the disk.

Useful commands:

```bash
pvcreate
vgcreate
lvcreate
lvextend
lvreduce
resize2fs
```

---

## 2. Shell Script Error Handling

### What I reviewed

```bash
set -e
set -u
set -o pipefail
trap
```

### What I learned again

- `set -e` stops the script when a command fails.
- `set -u` reports undefined variables.
- `set -o pipefail` detects failures inside pipelines.
- `trap` executes cleanup commands when the script exits or receives signals.

These options make production shell scripts much safer.

---

## 3. Git Rebase & Branching Strategies

### What I reviewed

- git rebase
- GitFlow
- GitHub Flow
- Trunk-Based Development

### What I learned again

Rebase creates a cleaner linear history by replaying commits on top of another branch.

Merge preserves branch history.

GitHub Flow is ideal for small agile teams.

GitFlow is useful for large projects with release branches.

Trunk-Based Development is preferred in modern CI/CD environments.

---

# Task 3 – Quick Fire Questions

## 1. What does chmod 755 script.sh do?

It gives:

- Owner → Read, Write, Execute
- Group → Read, Execute
- Others → Read, Execute

Only the owner can modify the file.

---

## 2. Difference between a process and a service?

**Process**

- Running instance of a program.
- Can be started manually.

**Service**

- Background process managed by systemd.
- Usually starts automatically during boot.

---

## 3. How do you find which process is using port 8080?

```bash
sudo ss -tulpn | grep :8080
```

or

```bash
sudo lsof -i :8080
```

---

## 4. What does set -euo pipefail do?

```bash
set -e
```

Exit immediately if a command fails.

```bash
set -u
```

Treat undefined variables as errors.

```bash
set -o pipefail
```

Return failure if any command inside a pipeline fails.

---

## 5. Difference between git reset --hard and git revert?

**git reset --hard**

- Removes commits permanently.
- Changes Git history.
- Dangerous on shared branches.

**git revert**

- Creates a new commit that reverses previous changes.
- Safe for shared repositories.
- Does not rewrite history.

---

## 6. Which branching strategy would you recommend for a team of 5 developers shipping weekly?

I would recommend **GitHub Flow** because it is simple, lightweight, supports pull requests, and works well with continuous deployment.

---

## 7. What does git stash do?

It temporarily saves uncommitted changes without committing them.

Useful when switching branches or pulling updates without losing work.

Commands:

```bash
git stash
git stash list
git stash pop
```

---

## 8. How do you schedule a script every day at 3 AM?

```cron
0 3 * * * /path/to/script.sh
```

Edit using:

```bash
crontab -e
```

---

## 9. Difference between git fetch and git pull?

**git fetch**

Downloads remote changes but does not merge them.

**git pull**

Downloads and automatically merges changes into the current branch.

---

## 10. What is LVM and why use it instead of regular partitions?

LVM (Logical Volume Manager) provides flexible storage management.

Advantages:

- Easy resizing
- Better storage utilization
- Snapshots
- Easier disk expansion
- No need to repartition disks

---

# Task 4 – Organize My Work

## Repository Checklist

- ✅ All Day 1–25 submissions committed
- ✅ All changes pushed to GitHub
- ✅ git-commands.md updated
- ✅ Shell scripting cheat sheet updated
- ✅ GitHub profile cleaned and organized
- ✅ Repository structure verified

---

# Task 5 – Teach It Back

## Explaining Git Branching to a Beginner

Git branching allows developers to work on different features without affecting the main project. Every branch is an independent line of development where code changes can be made safely. Once the feature is completed and tested, it is merged back into the main branch. This allows multiple developers to work simultaneously without overwriting each other's work. Branching also makes debugging, testing, and code reviews much easier. It is one of Git's most powerful features and is widely used in professional software development.

---

# Revision Summary

Today helped reinforce my understanding of everything covered over the last 28 days. I identified weaker topics such as LVM, shell script error handling, and Git branching strategies, reviewed them, and gained more confidence. I now have a stronger foundation in Linux, Shell Scripting, Git, GitHub, Networking, and DevOps fundamentals.

---

## Topics Revised

- DevOps Fundamentals
- Linux Commands
- Linux File System
- Users & Permissions
- Process Management
- Systemd
- Networking
- LVM
- Shell Scripting
- Crontab
- Git
- GitHub
- GitHub CLI
- GitHub Profile Optimization

---

## Next Goal

Continue building real-world DevOps projects using:

- Linux
- Git & GitHub
- Docker
- Kubernetes
- AWS
- Jenkins
- Terraform
- CI/CD Pipelines