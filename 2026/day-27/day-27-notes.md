# Day 27 – GitHub Profile Makeover: Build Your Developer Identity

> This is a branding day, not a coding day. Fill in the bracketed sections with your own honest answers as you work through each task.

---

## Task 1: Audit Your Current GitHub Profile

Go to `github.com/<your-username>` in an incognito/private window and look at it like a stranger would.

**Self-audit checklist:**

| Question | Your Answer |
|---|---|
| Is your profile picture professional? | `[YES/NO — describe current photo]` |
| Is your bio filled in? Does it say what you do? | `[current bio text, or "empty"]` |
| Are your pinned repos relevant, or random forks? | `[list what's currently pinned]` |
| Do your repos have descriptions? | `[YES/NO — how many are blank]` |
| Would a recruiter understand what you've worked on? | `[honest gut-check]` |

**Overall first impression (write 2–3 sentences, as if you were a recruiter landing on this profile cold):**
```
[Your honest first-impression notes here]
```

**Biggest gaps identified:**
- `[e.g. no profile README]`
- `[e.g. pinned repos are old course forks]`
- `[e.g. bio is empty]`

---

## Task 2: Create Your Profile README

### Steps
1. Create a new repository named **exactly** your GitHub username (e.g., if your username is `johndoe`, the repo must be `johndoe/johndoe`).
   ```bash
   gh repo create <your-username> --public --add-readme
   ```
   GitHub will detect the name match automatically and show a banner on your profile the first time — this only works if the repo name equals your username exactly.
2. Clone it and edit `README.md`:
   ```bash
   gh repo clone <your-username>
   cd <your-username>
   ```
3. Replace the README content with something like the template below.
4. Commit and push:
   ```bash
   git add README.md
   git commit -m "Add profile README"
   git push
   ```
5. Visit `github.com/<your-username>` to confirm it renders on your profile page.

### Profile README Template

Copy this into your `README.md`, then personalize every bracketed section. Keep it under ~20 lines of actual content — resist the urge to add more.

```markdown
### Hi, I'm [Your Name] 👋

I'm learning DevOps in public through the **90 Days of DevOps** challenge —
currently on Day 27, working through Linux, Git, scripting, and CI/CD fundamentals.

**Currently working on:**
- 🚀 90 Days of DevOps challenge — [link to repo]
- 🐧 Linux & shell scripting fundamentals
- 🔧 Learning CI/CD pipelines with GitHub Actions

**Tools & Skills:**
`Linux` · `Git & GitHub` · `Bash` · `Python` · `Docker` (learning) · `CI/CD` (learning)

**Check out my work:**
- 📘 [90 Days of DevOps](https://github.com/<username>/90-days-of-devops) — daily challenge submissions
- 🖥️ [Shell Scripts](https://github.com/<username>/shell-scripts) — bash scripting projects
- 🐍 [Python Scripts](https://github.com/<username>/python-scripts) — automation & scripting projects
- 📝 [DevOps Notes](https://github.com/<username>/devops-notes) — cheat sheets & learning notes

**Reach me:**
[LinkedIn](https://linkedin.com/in/yourprofile) · [Email](mailto:you@example.com)
```

**Design principles I followed (per the assignment's tips):**
- Kept it under 20 lines — no wall of text
- Used headers/bullets instead of paragraphs
- Focused on *current* work, not a resume dump
- Only 2–3 badges max, no "Christmas tree" of stats widgets
- Every linked repo actually exists and has a real README

---

## Task 3: Organize Your Repositories

For each repo below: create it, add a description, add a README, add a `.gitignore`, and move the relevant content in.

### 3.1 `90-days-of-devops`
```bash
gh repo create 90-days-of-devops --public \
  --description "My daily submissions for the 90 Days of DevOps challenge"
```
Suggested structure:
```
90-days-of-devops/
├── README.md
├── day-01/
├── day-02/
├── ...
└── day-27/
```
README should explain: what the challenge is, a link to the original challenge repo/creator, and a table of contents linking each day's folder.

### 3.2 `shell-scripts`
```bash
gh repo create shell-scripts --public \
  --description "Bash scripts from my DevOps learning journey (Days 16-21)"
```
Move your Day 16–21 scripts in, then document each one in the README, e.g.:

| Script | Description |
|---|---|
| `backup.sh` | `[what it does]` |
| `log-cleanup.sh` | `[what it does]` |
| `sys-health-check.sh` | `[what it does]` |

Add a `.gitignore`:
```
*.log
*.tmp
.DS_Store
```

### 3.3 `python-scripts`
```bash
gh repo create python-scripts --public \
  --description "Python automation scripts from my DevOps learning journey (Days 7-15)"
```
Same pattern — document each script in a table in the README.

Add a `.gitignore` (Python-specific):
```
__pycache__/
*.pyc
.venv/
venv/
.env
*.egg-info/
```

### 3.4 `devops-notes`
```bash
gh repo create devops-notes --public \
  --description "My cheat sheets and learning notes from the 90 Days of DevOps challenge"
```
Suggested structure, organized by topic:
```
devops-notes/
├── README.md
├── linux/
│   └── linux-cheatsheet.md
├── git/
│   └── git-commands.md
├── shell-scripting/
│   └── shell-scripting-cheatsheet.md   ← from Day 21
└── python/
    └── python-notes.md
```

**Repo checklist (apply to all four above):**
- [ ] Name uses hyphens, no spaces (`shell-scripts`, not `Shell Scripts`)
- [ ] One-line description set on GitHub (not left blank)
- [ ] README.md explains what's inside
- [ ] Relevant `.gitignore` added
- [ ] No secrets committed (see Task 5)

---

## Task 4: Pin Your Best Repos

Go to your profile → **Customize your pins** and select up to 6.

**My 6 pinned repos and why:**

| # | Repo | Why I pinned it |
|---|---|---|
| 1 | `[username]/[username]` | `[e.g. profile README — first thing visitors see]` |
| 2 | `90-days-of-devops` | `[shows consistency and range of the challenge]` |
| 3 | `shell-scripts` | `[demonstrates scripting ability]` |
| 4 | `python-scripts` | `[demonstrates scripting ability in a second language]` |
| 5 | `devops-notes` | `[shows learning process and documentation habits]` |
| 6 | `[your best individual project, if any]` | `[why it stands out]` |

Before pinning, double-checked each has: a description ✅, a README ✅.

---

## Task 5: Clean Up

### Repos deleted or archived
| Repo | Action | Reason |
|---|---|---|
| `[old-tutorial-fork]` | Deleted | `[empty / abandoned / not mine to showcase]` |
| `[test-repo]` | Deleted | `[was just for testing gh CLI commands]` |
| `[old-project]` | Archived | `[still has value as reference but no longer maintained]` |

```bash
gh repo delete <owner>/<repo> --yes      # permanent delete
gh repo archive <owner>/<repo>            # archive instead of delete
```

### Repos renamed
| Old name | New name | Reason |
|---|---|---|
| `[My Cool Project]` | `[my-cool-project]` | `spaces/caps replaced with hyphens, lowercase` |
| `[test123]` | `[weather-app-cli]` | `name didn't describe what it does` |

```bash
gh repo rename <new-name> --repo <owner>/<old-name>
```

### Secret scan
Checked every repo for committed `.env` files, API keys, tokens, and passwords — including commit **history**, not just current files (a deleted secret still exists in old commits).

```bash
# Check current tracked files for suspicious content
gh repo clone <owner>/<repo> && cd <repo>
grep -r -i -E "api[_-]?key|secret|password|token" . --exclude-dir=.git

# Check full commit history for a specific pattern
git log -p | grep -i -E "api[_-]?key|secret|password"

# Check if a .env file was ever committed, even if later removed
git log --all --full-history -- "*.env"
```

**Findings:**
```
[e.g. "No secrets found" OR "Found an API key in day-09/weather.py commit history —
rotated the key immediately and used git filter-repo / BFG to scrub it from history,
then force-pushed"]
```

> ⚠️ If you ever find a real secret in history: **rotate/revoke that credential immediately** (assume it's compromised the moment it's pushed, even briefly), then use `git filter-repo` or the BFG Repo-Cleaner to remove it from history and force-push.

---

## Task 6: Before & After

**Before screenshot:**
`[embed or link screenshot of profile before changes]`

**After screenshot:**
`[embed or link screenshot of profile after changes]`

### 3 things I improved and why

1. **`[e.g. Added a profile README]`** — `[why: previously the profile page was just a raw list of repos with zero context; now a visitor immediately understands what I'm learning and where to look]`
2. **`[e.g. Consolidated scattered scripts into shell-scripts and python-scripts repos]`** — `[why: previously daily scripts were buried inside a monolithic challenge repo with no descriptions; now each skill area has its own discoverable, documented repo]`
3. **`[e.g. Wrote real descriptions and READMEs for every pinned repo]`** — `[why: blank descriptions made the profile look abandoned/unfinished even though the work existed]`

---

## Reflections

Doing this audit made it clear that **code quality alone doesn't communicate anything if the packaging is bad** — a recruiter or maintainer skimming a profile for 15 seconds needs the README, the pins, and the descriptions to do the talking, since they're not going to read every file. Treating the GitHub profile as a "front door" rather than just a code dump was the main mindset shift from today.