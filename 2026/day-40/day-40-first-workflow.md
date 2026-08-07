# Day 40 – Your First GitHub Actions Workflow

---

# Objective

This is the first step toward building complete CI/CD pipelines.

---

# Challenge Task 1 – Repository Setup

## Step 1: Create a Repository

Create a new **public** GitHub repository named:

```
github-actions-practice has been created
```

---

## Step 2: Clone the Repository

```bash
git clone https://github.com/meraj0302/github-actions-practice.git

```

---

## Step 3: Create Workflow Folder

GitHub only detects workflow files inside:

```
.github/workflows/
```

Create it:

```bash
mkdir -p .github/workflows
```

This is look like below:

```
github-actions-practice/
│
├── .github/
│   └── workflows/
│       └── hello.yml
│
└── README.md
```

---

# Challenge Task 2 – Hello Workflow

Create a new workflow file:

```
.github/workflows/hello.yml
```

## Initial Workflow

```yaml
name: CI

on:
  push:
    branches: ["main"]

jobs:
  greet:
    runs-on: ubuntu-latest
    
    steps:
      - name: checkout rep code
        uses: actions/checkout@v4

      - name: print greeting
        run: echo "Hello Meraj Hru!"
        
```

---

## What happens?

Whenever I push code:

```
Git Push
      │
      ▼
GitHub detects push
      │
      ▼
Workflow starts
      │
      ▼
Checkout Repository
      │
      ▼
Print Greeting
      │
      ▼
Pipeline Success ✅

```

---

## Commit and Push

```bash
git add .

git commit -m "Added first GitHub Actions workflow"

git push origin main
```

---

## Verify

Open repository.

Click:

```
Actions
```

see:

```
✔ First GitHub Actions Workflow
```

Click the workflow.

Open the **greet** job.

Read every step and log.

---

# Challenge Task 3 – Understanding Workflow Anatomy

Below is the same workflow with explanations.

```yaml
name: CI

on:
  push:
    branches: ["main"]

jobs:
  greet:
    runs-on: ubuntu-latest
    
    steps:
      - name: checkout rep code
        uses: actions/checkout@v4

      - name: print greeting
        run: echo "Hello Meraj Hru!"

```

---

## 1. name:

Gives a human-readable name to the workflow.

Example:

```yaml
name: CI
```

Appears in the GitHub Actions tab.

---

## 2. on:

Specifies **when** the workflow should start.

Example:

```yaml
on:
  push:
    branches: ["main"]
```

Meaning:

Run this workflow every time code is pushed.

Other examples:

```yaml
on:
  pull_request:
```

```yaml
on:
  workflow_dispatch:
```

```yaml
on:
  schedule:
```

---

## 3. jobs:

Defines one or more jobs.

Example:

```yaml
jobs:
```

Each job runs independently.

A workflow can contain multiple jobs.

---

## 4. runs-on:

Specifies which operating system GitHub should use.

Example:

```yaml
runs-on: ubuntu-latest
```

Possible values:

```
ubuntu-latest

```

GitHub automatically creates a temporary virtual machine.

---

## 5. steps:

A list of actions performed inside a job.

Example:

```yaml
steps:
```

Each step runs in sequence.

---

## 6. uses:

Runs an existing GitHub Action.

Example:

```yaml
uses: actions/checkout@v4
```

This downloads our repository onto the runner.

Without it, the runner has no access to our project files.

---

## 7. run:

Executes shell commands.

Example:

```yaml
run: echo "Hello"
```

or

```yaml
run: ls
```

or

```yaml
run: python app.py
```

---

## 8. name: (inside a step)

Adds a descriptive label for the step.

Example:

```yaml
- name: Install Dependencies
```

Makes logs easier to understand.

---

# Challenge Task 4 – Add More Steps

Update workflow.

```yaml

name: CI

on:
  push:
    branches: ["main"]

jobs:
  greet:
    runs-on: ubuntu-latest
    
    steps:
      - name: checkout rep code
        uses: actions/checkout@v4

      - name: print greeting
        run: echo "Hello Meraj Hru!"

      - name: Print Current Date and Time
        run: date

      - name: Print Branch Name
        run: echo "${{ github.ref_name }}"

      - name: List Repository Files
        run: ls -la

      - name: Print Operating System
        run: echo "$RUNNER_OS"

```

---

---

# Understanding GitHub Variables

GitHub provides many built-in variables.

Example:

Current Branch

```yaml
${{ github.ref_name }}
```

Repository Name

```yaml
${{ github.repository }}
```

Actor

```yaml
${{ github.actor }}
```

Commit SHA

```yaml
${{ github.sha }}
```

Workflow Name

```yaml
${{ github.workflow }}
```

Runner OS

```bash
$RUNNER_OS
```

---

# Challenge Task 5 – Break It On Purpose

Modify your workflow.

```yaml
- name: Break Pipeline
  run: exit 1
```

or

```yaml
name: CI

on:
  push:
    branches: ["main"]

jobs:
  greet:
    runs-on: ubuntu-latest
    
    steps:
      - name: checkout rep code
        uses: actions/checkout@v4

      - name: print greeting
        run: echo "Hello Meraj Hru!"

      - name: Print Current Date and Time
        run: date

      - name: Print Branch Name
        run: echo "${{ github.ref_name }}"

      - name: List Repository Files
        run: lsss -la # this will break pipeline and throw an error

      - name: Print Operating System
        run: echo "$RUNNER_OS"
        
```

Push again.

---

## What Happens?

The pipeline stops immediately.

GitHub displays:

```
❌ Failed
```

The failed step becomes red.

Subsequent steps do not execute.

---

## Reading Errors

Example:

```
Run lssss

bash: lssss: command not found

Process completed with exit code 127.
```

Another example:

```
Run exit 1

Error:

Process completed with exit code 1.
```

The logs clearly identify:

- Which step failed
- Which command failed
- Exit code
- Error message

---

## Fix It

Remove the failing command.

Push again.

The pipeline becomes:

```
✔ Success
```

---

# Complete Workflow

```yaml
name: CI

on:
  push:
    branches: ["main"]

jobs:
  greet:
    runs-on: ubuntu-latest
    
    steps:
      - name: checkout rep code
        uses: actions/checkout@v4

      - name: print greeting
        run: echo "Hello Meraj Hru!"

      - name: Print Current Date and Time
        run: date

      - name: Print Branch Name
        run: echo "${{ github.ref_name }}"

      - name: List Repository Files
        run: ls -la

      - name: Print Operating System
        run: echo "$RUNNER_OS"
        
```

---

# Pipeline Flow Diagram

```
                Developer

                    │

               git push

                    │

                    ▼

      GitHub detects repository push

                    │

                    ▼

       Trigger Workflow (hello.yml)

                    │

                    ▼

     Checkout Repository Source Code

                    │

                    ▼

       Print Hello Message

                    │

                    ▼

      Print Current Date & Time

                    │

                    ▼

        Print Branch Name

                    │

                    ▼

      List Repository Files

                    │

                    ▼

     Print Runner Operating System

                    │

                    ▼

           Pipeline Completed

                    │

                    ▼

               Success ✅
```

---

# What a Successful Pipeline Looks Like

```
✔ Workflow Started

✔ Checkout Repository

✔ Print Greeting

✔ Print Date

✔ Print Branch

✔ List Files

✔ Print Runner OS

✔ Job Completed
```

Everything is green.

---

# What a Failed Pipeline Looks Like

```
✔ Checkout Repository

✔ Print Greeting

❌ Wrong Command

Skipped Remaining Steps
```

The workflow status changes to **Failed**.

Click the failed step to view detailed logs.

---

# Key Takeaways

- GitHub Actions automatically runs workflows in the cloud.
- Workflows are stored inside `.github/workflows/`.
- Every workflow is written in YAML.
- `on:` defines when the workflow starts.
- `jobs:` groups related work.
- `steps:` execute commands sequentially.
- `uses:` runs reusable GitHub Actions.
- `run:` executes shell commands.
- Every push can automatically trigger a CI pipeline.
- Reading logs is the fastest way to debug pipeline failures.

---

# Quick Revision

| Keyword | Purpose |
|---------|---------|
| `name` | Workflow or step name |
| `on` | Defines trigger events |
| `jobs` | Collection of jobs |
| `runs-on` | Runner operating system |
| `steps` | Commands inside a job |
| `uses` | Runs an existing GitHub Action |
| `run` | Executes shell commands |

---

# Interview Questions

### What is GitHub Actions?

GitHub Actions is GitHub's built-in CI/CD platform that automates software workflows like building, testing, and deploying applications.

---

### Where are GitHub workflow files stored?

```
.github/workflows/
```

---

### What language is used to write workflows?

YAML.

---

### What does `actions/checkout@v4` do?

It checks out the repository code onto the GitHub Actions runner so workflow steps can access the project files.

---

### What is a runner?

A runner is the machine (virtual or self-hosted) that executes GitHub Actions workflow jobs.

---

### What happens when a workflow step fails?

The job stops execution, the workflow is marked as failed, and the error details are available in the workflow logs.

---

# Screenshot (To Add After Completion)

After your workflow runs successfully:

1. Open **GitHub Repository**
2. Click **Actions**
3. Open the latest successful workflow
4. Take a screenshot showing the **green checkmark** and completed steps
5. Insert it below this section before submission


---

# Submission Checklist

- ✅ Created `github-actions-practice` repository
- ✅ Created `.github/workflows/hello.yml`
- ✅ Triggered workflow on push
- ✅ Understood workflow anatomy
- ✅ Added additional workflow steps
- ✅ Intentionally broke the pipeline
- ✅ Fixed the pipeline
- ✅ Captured successful workflow screenshot
- ✅ Completed `day-40-first-workflow.md`

---

**Day 40 Complete ✅**