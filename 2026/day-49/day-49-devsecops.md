# Day 49 – DevSecOps: Add Security to Your CI/CD Pipeline

## Overview

Today I upgraded my GitHub Actions CI/CD pipeline with DevSecOps practices.

Instead of waiting until deployment or production to discover security problems, security checks are now performed automatically during the software delivery process. My pipeline now checks Docker images for vulnerabilities, reviews new dependencies, protects repository secrets, and uses least-privilege workflow permissions.

---

## What is DevSecOps?

DevSecOps means integrating security into the normal software development and CI/CD process instead of treating security as a separate activity.

In my pipeline, security checks happen automatically before code is merged or deployed. This helps catch vulnerabilities and leaked secrets early, reduces security risk, and makes security part of everyday development.

---

# Security Improvements Added

## 1. Docker Image Vulnerability Scanning

I added Trivy to my main CI/CD pipeline.

Trivy scans the Docker image for known vulnerabilities in operating-system packages and application libraries.

```yaml
- name: Scan Docker Image for Vulnerabilities
  uses: aquasecurity/trivy-action@v0.36.0
  with:
    image-ref: '${{ secrets.DOCKERHUB_USERNAME }}/github-actions-capstone:${{ github.sha }}'
    format: 'table'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
    vuln-type: 'os,library'
```

The important configuration is:

| Setting                   | Purpose                                       |
| ------------------------- | --------------------------------------------- |
| `image-ref`               | Docker image to scan                          |
| `format: table`           | Displays readable results                     |
| `exit-code: 1`            | Fails the workflow when vulnerabilities match |
| `severity: CRITICAL,HIGH` | Blocks serious vulnerabilities                |
| `vuln-type: os,library`   | Checks OS and application dependencies        |

### Security Gate

```text
Docker Build
     ↓
Trivy Scan
     ↓
HIGH / CRITICAL?
   /       \
 YES        NO
 ↓          ↓
FAIL       PASS
 ↓          ↓
STOP       PUSH
```

The Docker image is therefore not pushed or deployed when the Trivy security gate fails.

---

# 2. Trivy Scan Result

The Trivy scan was executed from my GitHub Actions pipeline.

The scan output displays vulnerability information including:

* Vulnerability ID / CVE
* Package name
* Installed version
* Fixed version, when available
* Severity
* Vulnerability description

## Screenshot

> **Add your actual GitHub Actions screenshot here.**
>
> Recommended screenshot:
>
> `GitHub → Actions → Workflow Run → Trivy scan step`
>
> The screenshot should clearly show the `Scan Docker Image for Vulnerabilities` step and the Trivy vulnerability table.

```text
[ INSERT TRIVY GITHUB ACTIONS SCREENSHOT HERE ]
```

### Scan Result

**Scan status:** Replace with `PASSED` or `FAILED` after running the workflow.

**Base image:** Replace with the base image from my Dockerfile.

**Critical vulnerabilities:** Replace with the number shown by Trivy.

**High vulnerabilities:** Replace with the number shown by Trivy.

**CVE examples:** Replace with the CVE IDs displayed in the actual scan.

> I will not claim a vulnerability count or CVE number without checking the actual GitHub Actions scan output.

---

# 3. GitHub Secret Scanning

I enabled GitHub Secret Scanning for the repository.

Secret scanning searches the repository for supported credentials such as:

* API keys
* Access tokens
* Cloud credentials
* Passwords
* Authentication secrets

This helps identify credentials that may have accidentally been committed to the repository.

---

# 4. Secret Scanning vs Push Protection

| Feature      | Secret Scanning                  | Push Protection                        |
| ------------ | -------------------------------- | -------------------------------------- |
| Main purpose | Detect leaked secrets            | Prevent secrets from being pushed      |
| Timing       | After/during repository scanning | Before the push reaches the repository |
| Result       | Creates an alert                 | Blocks the push                        |
| Goal         | Detection                        | Prevention                             |

For example:

```text
Developer writes AWS key
          ↓
       git push
          ↓
   Push Protection
          ↓
     Secret found?
       /       \
     YES        NO
      ↓          ↓
   BLOCK       PUSH
```

Push protection is especially useful because it can prevent a supported secret from reaching the repository in the first place.

---

# 5. What Happens If an AWS Key Is Leaked?

If a real AWS credential is detected, I should treat it as compromised.

The response should be:

```text
AWS key detected
       ↓
Immediately revoke/rotate key
       ↓
Remove secret from source code
       ↓
Review repository/history if required
       ↓
Create replacement credential
       ↓
Store credential securely
       ↓
Use GitHub Secrets / OIDC
```

A leaked credential should never simply be ignored because the line was deleted from the latest commit.

---

# 6. Dependency Vulnerability Review

I added GitHub's Dependency Review Action to my pull-request pipeline.

```yaml
- name: Check Dependencies for Vulnerabilities
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

This check evaluates dependency changes introduced by a pull request.

The purpose is to prevent a new vulnerable dependency from being introduced into the project without detection.

### PR Flow

```text
Pull Request
     ↓
Build
     ↓
Tests
     ↓
Dependency Review
     ↓
Critical vulnerability?
   /          \
 YES           NO
 ↓             ↓
FAIL          PASS
```

---

# 7. Workflow Permissions

I added least-privilege permissions to my workflows.

```yaml
permissions:
  contents: read
```

This gives the workflow only the repository-content permission it needs.

Instead of giving every workflow broad write permissions, I should provide only the permissions required by the individual job.

For example, if a workflow genuinely needs to modify pull requests:

```yaml
permissions:
  contents: read
  pull-requests: write
```

### Why Least Privilege Matters

If a third-party GitHub Action becomes compromised and the workflow has unnecessary write permissions, the compromised action could potentially modify repository content or other resources available through its GitHub token.

Limiting permissions reduces the possible impact of a compromised action.

---

# 8. Complete DevSecOps Pipeline

```text
                         DEVSECOPS CI/CD PIPELINE
                                  │
                                  ▼
                         Developer opens PR
                                  │
                                  ▼
                              Build
                                  │
                                  ▼
                               Test
                                  │
                                  ▼
                     Dependency Vulnerability
                              Review
                                  │
                           ┌──────┴──────┐
                           │             │
                         FAIL          PASS
                           │             │
                           ▼             ▼
                       PR blocked     PR approved
                                         │
                                         ▼
                                  Merge to main
                                         │
                                         ▼
                                  Docker Build
                                         │
                                         ▼
                                    Trivy Scan
                                         │
                              ┌──────────┴──────────┐
                              │                     │
                       HIGH/CRITICAL             Clean
                              │                     │
                              ▼                     ▼
                           STOP ❌              Docker Push
                                                    │
                                                    ▼
                                                  Deploy


                  CONTINUOUS REPOSITORY PROTECTION
                  ┌───────────────────────────────┐
                  │ Secret Scanning               │
                  │ Push Protection               │
                  │ Least-Privilege Permissions   │
                  └───────────────────────────────┘
```

---

# 9. Security Checks Added

| Security Control  | Pipeline Location | Purpose                                     |
| ----------------- | ----------------- | ------------------------------------------- |
| Trivy             | Main pipeline     | Scan Docker image                           |
| Dependency Review | Pull Request      | Detect vulnerable dependency changes        |
| Secret Scanning   | Repository        | Detect exposed credentials                  |
| Push Protection   | GitHub repository | Prevent supported secrets from being pushed |
| Permissions       | Workflows         | Apply least privilege                       |

---

# 10. Before vs After

## Before DevSecOps

```text
Code
 ↓
Build
 ↓
Test
 ↓
Docker Build
 ↓
Docker Push
 ↓
Deploy
```

Security was not an explicit automated gate.

## After DevSecOps

```text
PR
 ↓
Build
 ↓
Test
 ↓
Dependency Review
 ↓
Merge
 ↓
Docker Build
 ↓
Trivy Security Scan
 ↓
Docker Push
 ↓
Deploy

PLUS:

Secret Scanning
Push Protection
Least-Privilege Permissions
```

---

# 11. What I Learned

### DevSecOps

Security should be integrated into the existing development and CI/CD workflow instead of being treated as a final production check.

### Trivy

Trivy can scan container images for known vulnerabilities. Configuring the pipeline with `exit-code: '1'` makes the security scan a real quality gate.

### Secret Scanning

GitHub Secret Scanning helps identify credentials that have been exposed in a repository.

### Push Protection

Push protection goes one step further by preventing supported secrets from reaching the repository during the push process.

### Dependency Review

Dependency Review helps identify security problems introduced through dependency changes in pull requests.

### Permissions

GitHub Actions workflows should use the minimum permissions required to perform their jobs.

---

# 12. Final Result

My CI/CD pipeline now follows a basic DevSecOps model:

```text
                SECURITY BUILT INTO CI/CD

Developer
    │
    ▼
   Pull Request
    │
    ├── Build
    ├── Test
    └── Dependency Review
              │
              ▼
          Merge to main
              │
              ▼
        Docker Build
              │
              ▼
         Trivy Scan
              │
              ▼
        Security Gate
          /       \
       FAIL       PASS
        │           │
        ▼           ▼
       STOP      Docker Push
                    │
                    ▼
                  Deploy

Always:
    ├── Secret Scanning
    ├── Push Protection
    └── Least-Privilege Permissions
```

## Conclusion

Day 49 showed me that DevSecOps does not require creating a completely separate security process. Security can be added directly into CI/CD through automated vulnerability scanning, dependency checks, secret protection, and restricted workflow permissions.

The main lesson I learned is:

> **Build security into the pipeline instead of checking security after deployment.**
