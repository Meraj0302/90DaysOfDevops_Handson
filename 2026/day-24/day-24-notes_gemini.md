# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

## Task 1: Git Merge — Hands-On

### Observations
1. **`feature-login` Merge:** Since `main` did not have any new commits after `feature-login` was created, Git performed a **Fast-Forward (FF)** merge. No new merge commit was created; the pointer for `main` simply moved forward to the tip of `feature-login`.
2. **`feature-signup` Merge:** Because `main` moved ahead with an independent commit while `feature-signup` was being worked on, Git could not do a fast-forward merge. It automatically generated a **Three-way Merge** and created a new **Merge Commit**.

### Q&A

* **What is a fast-forward merge?**
    A fast-forward merge occurs when the target branch (`main`) has no new commits since the source branch (`feature-login`) was split off. Git simply moves the branch pointer forward to the latest commit of the source branch without creating a new history commit.
    
* **When does Git create a merge commit instead?**
    Git creates a merge commit when the histories of the two branches have diverged (i.e., new commits have been made on `main` *and* new commits have been made on the feature branch since they split). Git must combine the two histories using a three-way merge algorithm, generating a new "Merge Commit" that has two parent commits.

* **What is a merge conflict?**
    A merge conflict occurs when Git cannot automatically reconcile differences between two branches. This typically happens when two different branches modify the exact same line(s) of a file, or when one branch deletes a file that another branch modified. Git pauses the merge and asks the user to manually select which changes to keep.

---

## Task 2: Git Rebase — Hands-On

### Observations
When running `git log --oneline --graph --all` after the rebase, the history appears as a perfectly straight, linear line. It looks as if the `feature-dashboard` work was started *after* the latest commit on `main`, completely eliminating the visual branching and merging paths seen in a standard merge.

### Q&A

* **What does rebase actually do to your commits?**
    Rebasing takes all the unique commits from your current branch, temporarily sets them aside, moves your branch's base tip to match the target branch's latest commit, and then re-applies (re-writes) your unique commits one-by-one on top of that new base. 

* **How is the history different from a merge?**
    * **Merge:** Retains the true chronological order of events and explicitly shows the branching and joining paths. It adds a new merge commit to the history.
    * **Rebase:** Rewrites history to make it completely linear. It does not create an extra merge commit, making the log cleaner but technically altering the exact time-sequence context of when the code was written.

* **Why should you never rebase commits that have been pushed and shared with others?**
    Rebasing alters commit IDs (SHA-1 hashes) because it recreates commits on a new base. If you rebase commits already pushed to a public repository, you rewrite history that others have based their work on. This causes major sync conflicts, duplicated commits, and broken histories for your teammates. **Rule of thumb: Only rebase local, unpushed branches.**

* **When would you use rebase vs merge?**
    * **Use Rebase:** On local feature branches to pull in the latest changes from `main` to keep your local branch clean, updated, and linear before making a pull request.
    * **Use Merge:** When incorporating feature branches into `main` or production lines where preserving the exact historical context and true collaborative timeline is critical.

---

## Task 3: Squash Commit vs Merge Commit

### Observations
1. **`feature-profile` (Squash):** Git took all 4-5 small commits and compressed them into a single blob of changes. Checking `git log` on `main` showed that only **one single commit** was added to the history of `main`.
2. **`feature-settings` (Regular Merge):** A regular merge preserved every individual commit from the feature branch along with an additional merge commit. The history log remained crowded with small, intermediate commits.

### Q&A

* **What does squash merging do?**
    Squash merging combines all metadata and changes from a series of commits on a feature branch into a single, unified commit, which is then applied directly to the target branch.

* **When would you use squash merge vs regular merge?**
    * **Squash Merge:** Ideal for merging short-lived feature branches filled with messy, minor commits ("fixed typo", "wip", "testing formatting") into public tracking branches like `main` or `develop`.
    * **Regular Merge:** Ideal for long-running feature branches, epics, or sub-systems where keeping individual granular commits is crucial for tracking down bugs or understanding complex architectural evolutions step-by-step.

* **What is the trade-off of squashing?**
    * **Pros:** Keeps the destination branch history clean, concise, and incredibly easy to read.
    * **Cons:** Erases the granular historical context and evolution steps of the feature. It becomes impossible to revert only one specific sub-part of that feature later on because everything is baked into a single commit.

---

## Task 4: Git Stash — Hands-On

### Observations
* Attempting to switch branches with uncommitted, tracked changes that conflict with the destination branch results in Git throwing an error preventing the checkout (`error: Your local changes to the following files would be overwritten by checkout`).
* Using `git stash` cleanly wipes the working directory back to the last commit, allowing for seamless branch switching.
* `git stash list` shows an indexed array of saved states (`stash@{0}`, `stash@{1}`, etc.).

### Q&A

* **What is the difference between `git stash pop` and `git stash apply?`**
    * `git stash pop`: Applies the most recent (or specified) stashed changes back to your working directory and **removes** it from the stash stack entirely.
    * `git stash apply`: Applies the stashed changes back to your working directory but **keeps** the copy safely inside the stash stack for future use.

* **When would you use stash in a real-world workflow?**
    You would use it when you are deep into coding a new feature on your branch, but an urgent bug or production hotfix lands that requires you to immediately jump to another branch. Stashing lets you pause, save your half-baked work safely without making an ugly "WIP" commit, jump away to fix the bug, and then restore your exact working environment upon return.

---

## Task 5: Cherry Picking

### Observations
By identifying the hash of the second commit on `feature-hotfix` using `git log --oneline` and running `git cherry-pick <commit-hash>`, only that specific change was isolated and baked onto `main`. The other two commits from `feature-hotfix` did not move over.

### Q&A

* **What does cherry-pick do?**
    Cherry-picking takes the exact changes introduced by a specific commit from *any* branch and applies them as a brand new commit onto your *current* checked-out branch.

* **When would you use cherry-pick in a real project?**
    * When an urgent bug fix was inadvertently committed to a feature branch instead of `main`, and you need to bring *just* that fix to production immediately without bringing the uncompleted feature with it.
    * Porting a specific patch or enhancement from an older release branch directly onto the current development branch.

* **What can go wrong with cherry-picking?**
    * **Duplicate Commits:** It creates a brand-new commit with a new SHA-1 hash but the same content, which can cause confusion or duplicate changes when branches are eventually merged downstream.
    * **Dependency Conflicts:** If the cherry-picked commit relies on code or changes made in commits *prior* to it on the original branch, it will cause painful merge conflicts or break compilation on the target branch.