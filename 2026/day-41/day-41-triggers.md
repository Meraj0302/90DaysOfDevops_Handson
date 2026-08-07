# Day 41 – Triggers & Matrix Builds

---

# Objective

So far, my workflow runs only when code is pushed. In real-world DevOps projects, workflows can also run:

- When a Pull Request is created
- On a schedule
- Manually
- Across multiple operating systems and language versions

Today I'll explore all of these.

---

# GitHub Actions Trigger Types

GitHub Actions supports many trigger events.

Some common ones are:

| Trigger | Description |
|----------|-------------|
| `push` | Runs when code is pushed |
| `pull_request` | Runs when a Pull Request is created or updated |
| `workflow_dispatch` | Runs manually from the GitHub UI |
| `schedule` | Runs automatically using cron syntax |
| `release` | Runs when a GitHub Release is published |
| `workflow_call` | Called from another workflow |
| `repository_dispatch` | Triggered using GitHub API |
| `issues` | Runs when an issue is opened or modified |

---

# Challenge Task 1 – Pull Request Trigger

## Objective

Run a workflow whenever a Pull Request is opened or updated against the `main` branch.

---

## Create Workflow

```
.github/workflows/pr-check.yml
```

---

## Workflow

```yaml
name: Pull Request Check

on:
  pull_request:
    branches:
      - main
    types:
      - opened
      - synchronize

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Branch Name
        run: echo "PR check running for branch: ${{ github.head_ref }}"
```

---

## Explanation

### `pull_request`

Runs when a Pull Request event occurs.

---

### `branches`

```yaml
branches:
  - main
```

Only PRs targeting the **main** branch trigger the workflow.

---

### `types`

```yaml
types:
  - opened
  - synchronize
```

- `opened` → PR created
- `synchronize` → New commits pushed to the PR

---

## Testing

Create a new branch.

```bash
git checkout -b feature/login
```

Make any change.

```bash
git add .

git commit -m "Added login page"

git push origin feature/login
```

Open a Pull Request.

Navigate to:

```
GitHub Repository
↓
Pull Requests
↓
Create Pull Request

```

GitHub automatically starts the workflow.

---

# Challenge Task 2 – Scheduled Trigger

GitHub Actions can execute workflows automatically at scheduled times.

---

## Workflow Example

```yaml
name: Daily Workflow

on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  daily-job:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Running every midnight UTC"
```

---

## Cron Expression

```
0 0 * * *
```

Meaning:

```
Minute Hour Day Month Weekday

0      0    *    *      *
```

Runs every day at:

```
00:00 UTC
```

---

## Cron for Every Monday at 9 AM UTC

```
0 9 * * 1
```

Explanation:

```
Minute = 0

Hour = 9

Every Day

Every Month

Monday = 1
```

---

## Useful Cron Examples

| Cron | Meaning |
|-------|---------|
| `0 0 * * *` | Every day at midnight |
| `0 9 * * 1` | Every Monday at 9 AM |
| `*/10 * * * *` | Every 10 minutes |
| `0 */6 * * *` | Every 6 hours |
| `30 18 * * 5` | Every Friday at 6:30 PM |

---

# Challenge Task 3 – Manual Trigger

Sometimes we want to run workflows manually.

GitHub provides:

```
workflow_dispatch
```

---

## Create Workflow

```
.github/workflows/manual.yml
```

---

## Workflow

```yaml
name: Manual Deployment

on:
  workflow_dispatch:

jobs:
  manual-job:

    runs-on: ubuntu-latest

    steps:
      - name: Print Selected Environment
        run: echo "Environment: ${{ github.event.inputs.environment }}"
```

---

## Running It

Open:

```
GitHub

↓

Actions

↓

Manual Deployment

↓

Run workflow

```

---

# Challenge Task 4 – Matrix Builds

## Why Matrix Builds?

Instead of writing three workflows:

```
Python 3.10

Python 3.11

Python 3.12
```

GitHub automatically creates multiple jobs.

---

## Workflow

```
.github/workflows/matrix.yml
```

```yaml
name: Matrix Build

on:
  push:

jobs:

  test:

    runs-on: ubuntu-latest

    strategy:

      matrix:

        python-version:

          - "3.10"

          - "3.11"

          - "3.12"

    steps:

      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Print Version
        run: python --version
```

---

## What Happens?

GitHub creates:

```
Job 1 → Python 3.10

Job 2 → Python 3.11

Job 3 → Python 3.12
```

All run simultaneously.

---

# Extend Matrix with  double Operating Systems

```yaml

name: Double OS Matrix Build

on:
  push:

jobs:
  test:
    strategy:
        matrix:
            os:
            - ubuntu-latest
            - windows-latest
            python-version:
            - "3.10"
            - "3.11"
            - "3.12"
    runs-on: ${{ matrix.os }}

    steps:

      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Print Version
        run: python --version

```

---

## Jobs Created

| Operating System | Python |
|-----------------|---------|
| Ubuntu | 3.10 |
| Ubuntu | 3.11 |
| Ubuntu | 3.12 |
| Windows | 3.10 |
| Windows | 3.11 |
| Windows | 3.12 |

---

Total Jobs:

```
2 × 3 = 6 Jobs
```

All execute in parallel.

---

# Challenge Task 5 – Exclude & Fail-Fast

## Excluding One Combination

Suppose Python 3.10 doesn't support Windows.

```yaml
name: Double OS with exclude Matrix Build

on:
  push:

jobs:
  test:
    strategy:
        matrix:
            os:
            - ubuntu-latest
            - windows-latest
            python-version:
            - "3.10"
            - "3.11"
            - "3.12"
            exclude:
                - os: windows-latest
                  python-version: "3.10"

    runs-on: ${{ matrix.os }}

    steps:

      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}

      - name: Print Version
        run: python --version

```

---

## Jobs Now

| OS | Python |
|----|---------|
| Ubuntu | 3.10 |
| Ubuntu | 3.11 |
| Ubuntu | 3.12 |
| Windows | 3.11 |
| Windows | 3.12 |

Total:

```
5 Jobs
```

---

## Trigger Failure

Add a failing step.

```yaml
- name: Fail Job
  run: exit 1
```

---

## Observe

One job fails.

Others continue running because:

```yaml
fail-fast: false
```

---

# What is `fail-fast`?

## Default

```yaml
fail-fast: true
```

Behavior:

If one matrix job fails,

GitHub immediately cancels the remaining running jobs.

Example:

```
Ubuntu 3.10 ❌

Ubuntu 3.11 Cancelled

Windows 3.11 Cancelled
```

This saves build time and resources.

---

## With `fail-fast: false`

Behavior:

If one job fails,

GitHub continues executing all remaining jobs.

Example:

```
Ubuntu 3.10 ❌

Ubuntu 3.11 ✅

Ubuntu 3.12 ✅

Windows 3.11 ✅

Windows 3.12 ✅
```

This is useful when you want to see the results of every environment.

---

# Pipeline Flow Diagram

```
                 Developer

                     │

               git push

                     │

                     ▼

             Trigger Workflow

                     │

                     ▼

              Matrix Strategy

          ┌──────────┼──────────┐

          ▼          ▼          ▼

     Python 3.10  Python 3.11  Python 3.12

          │          │          │

          ▼          ▼          ▼

    Ubuntu Job   Ubuntu Job   Ubuntu Job

          │          │          │

          ▼          ▼          ▼

   Windows Job Windows Job Windows Job

          │          │          │

          └──────────┼──────────┘

                     ▼

             Pipeline Complete
```

---

# Key Takeaways

- `push` runs workflows after code is pushed.
- `pull_request` runs workflows during Pull Requests.
- `schedule` runs workflows automatically using cron syntax.
- `workflow_dispatch` allows manual execution from GitHub.
- Matrix builds execute multiple job combinations in parallel.
- `exclude` removes unwanted matrix combinations.
- `fail-fast: false` allows all matrix jobs to complete even if one fails.
- Matrix builds are commonly used to test software on multiple operating systems and language versions.

---

# Quick Revision

| Feature | Purpose |
|---------|---------|
| `push` | Trigger on code push |
| `pull_request` | Trigger on Pull Request |
| `schedule` | Trigger using cron |
| `workflow_dispatch` | Manual execution |
| `matrix` | Run jobs in parallel |
| `exclude` | Remove matrix combinations |
| `fail-fast` | Stop or continue other jobs after a failure |

---

# Interview Questions

### What is a Pull Request trigger?

A workflow event that runs when a Pull Request is opened, synchronized, reopened, or updated.

---

### What is `workflow_dispatch`?

It allows users to manually trigger a GitHub Actions workflow from the GitHub Actions tab, optionally with custom inputs.

---

### What is a matrix build?

A strategy that automatically creates multiple parallel jobs using different combinations of variables such as operating systems, language versions, or architectures.

---

### How many jobs will run if you have 2 operating systems and 3 Python versions?

```
2 × 3 = 6 Jobs
```

---

### What does `exclude` do in a matrix?

It removes specific combinations from the matrix so those jobs are not created.

---

### What is the difference between `fail-fast: true` and `fail-fast: false`?

- **`fail-fast: true` (default):** Stops or cancels the remaining matrix jobs when one job fails, saving time and resources.
- **`fail-fast: false`:** Allows all matrix jobs to continue and finish even if one or more jobs fail, which is useful for testing across all environments.

---

# Submission Checklist

- ✅ Created `pr-check.yml`
- ✅ Tested Pull Request trigger
- ✅ Added scheduled trigger
- ✅ Learned cron expressions
- ✅ Created `manual.yml`
- ✅ Tested manual workflow with input
- ✅ Created `matrix.yml`
- ✅ Ran jobs across Python versions
- ✅ Extended matrix with multiple operating systems
- ✅ Used `exclude`
- ✅ Tested `fail-fast`
- ✅ Understood matrix builds

---

# Folder Structure

```
github-actions-practice/
│
├── .github/
│   └── workflows/
│       ├── hello.yml
│       ├── pr-check.yml
│       ├── manual.yml
│       └── matrix.yml
│
└── README.md
```

---

**Day 41 Complete ✅**