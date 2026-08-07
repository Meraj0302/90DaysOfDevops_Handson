# Day 39 – What is CI/CD?

---

# Why CI/CD Exists

As software projects grow, multiple developers work on the same application simultaneously. Without automation, integrating code and deploying applications becomes slow, error-prone, and difficult to manage.

CI/CD helps teams:
- Detect bugs early
- Automate repetitive tasks
- Deliver software faster
- Improve code quality
- Reduce deployment risks
- Ensure every change is tested before reaching users

> **Important:** CI/CD is a software development practice, not a tool.

Popular CI/CD tools include:
- GitHub Actions
- Jenkins
- GitLab CI/CD
- CircleCI
- Azure DevOps
- Bitbucket Pipelines

---

# Challenge Task 1 – The Problem

## Scenario

Imagine a team of **5 developers** working on the same GitHub repository.

Every developer manually:
- Writes code
- Tests locally
- Pushes code
- Deploys to production

## What can go wrong?

- Merge conflicts
- Broken application after deployment
- Developers overwrite each other's changes
- Manual deployment mistakes
- Forgetting deployment steps
- Different software versions
- Missing dependencies
- No automated testing
- Longer release time
- Difficult rollback if deployment fails

---

## What does "It Works on My Machine" mean?

"It works on my machine" means the application runs correctly on the developer's computer but fails on another developer's machine or in production.

### Common Reasons

- Different operating systems
- Different package versions
- Missing environment variables
- Missing dependencies
- Different database versions
- Different configurations

### Why is this a real problem?

It wastes development time because developers spend hours trying to reproduce issues that only occur in other environments.

CI/CD solves this by testing code in a consistent environment.

---

## How many times a day can a team safely deploy manually?

Usually only **1–2 deployments per day**, depending on the application's complexity.

Manual deployments are:
- Slow
- Error-prone
- Risky
- Difficult to repeat consistently

With automated CI/CD, many organizations deploy dozens or even hundreds of times per day.

---

# Challenge Task 2 – CI vs CD

## 1. Continuous Integration (CI)

### Definition

Continuous Integration is the practice of automatically building and testing code whenever developers push changes to a shared repository.

It helps detect bugs early by frequently integrating code changes.

### What happens?

- Code is pushed
- Pipeline starts
- Application builds
- Tests execute
- Results are reported

### How often?

Every commit or pull request.

### What does it catch?

- Build failures
- Compilation errors
- Unit test failures
- Code quality issues
- Integration problems

### Real-world Example

A developer pushes code to GitHub.

GitHub Actions automatically:
- Builds the project
- Runs unit tests
- Reports success or failure

If tests fail, the code should not be merged.

---

## 2. Continuous Delivery (CD)

### Definition

Continuous Delivery automatically prepares software for deployment after CI succeeds, but production deployment requires **manual approval**.

The application is always in a deployable state.

### What does "Delivery" mean?

The application is automatically built, tested, and packaged, ready for deployment whenever the team decides.

### Real-world Example

After passing all tests:

- Docker image is built
- Image is pushed to Docker Hub
- Deployment waits for manager approval

Someone clicks **Deploy**.

---

## 3. Continuous Deployment

### Definition

Continuous Deployment automatically deploys every successful change directly to production without manual approval.

If all pipeline stages succeed, deployment happens automatically.

### When do teams use it?

- SaaS companies
- Cloud-native applications
- Frequent release environments
- Teams with excellent automated testing

### Real-world Example

Developer pushes code →

Tests pass →

Docker image builds →

Application automatically deploys to Kubernetes production cluster.

No human intervention required.

---

# CI vs Continuous Delivery vs Continuous Deployment

| Feature | Continuous Integration | Continuous Delivery | Continuous Deployment |
|----------|-----------------------|--------------------|-----------------------|
| Build Automatically | ✅ | ✅ | ✅ |
| Run Tests | ✅ | ✅ | ✅ |
| Package Application | ❌ | ✅ | ✅ |
| Manual Approval | ❌ | ✅ | ❌ |
| Deploy to Production | ❌ | Manual | Automatic |

---

# Challenge Task 3 – Pipeline Anatomy

## 1. Trigger

A trigger starts the pipeline.

Common triggers:
- Git push
- Pull Request
- Schedule (cron)
- Manual workflow
- Tag creation
- Release creation

Example:

```
git push origin main
```

This push starts the pipeline.

---

## 2. Stage

A stage is a major phase of the pipeline.

Common stages:

- Build
- Test
- Security Scan
- Package
- Deploy

Stages organize related jobs.

---

## 3. Job

A job is a collection of related steps executed on the same runner.

Example:

Build Job

- Install dependencies
- Compile application
- Create Docker image

---

## 4. Step

A step is a single command or action inside a job.

Example:

```
npm install
```

Another example:

```
docker build -t myapp .
```

Every job contains multiple steps.

---

## 5. Runner

A runner is the machine that executes pipeline jobs.

Examples:

- GitHub-hosted runner
- Self-hosted runner
- Jenkins Agent

Example:

```
runs-on: ubuntu-latest
```

GitHub provides a temporary Ubuntu VM to execute the workflow.

---

## 6. Artifact

Artifacts are files generated during the pipeline and stored for later use.

Examples:

- ZIP files
- Build binaries
- Docker images
- Test reports
- Coverage reports
- Log files

Artifacts allow later stages to reuse outputs from earlier stages.

---

# Challenge Task 4 – Pipeline Diagram

## Text-Based CI/CD Pipeline

```
                 Developer
                     |
                     |
             git push to GitHub
                     |
                     v
            +------------------+
            | Trigger Pipeline |
            +------------------+
                     |
                     v
            +------------------+
            | Build Stage      |
            | Install Packages |
            | Compile Code     |
            +------------------+
                     |
                     v
            +------------------+
            | Test Stage       |
            | Unit Tests       |
            | Integration Test |
            +------------------+
                     |
                     v
            +-------------------------+
            | Docker Build Stage      |
            | Create Docker Image     |
            +-------------------------+
                     |
                     v
            +----------------------+
            | Push Image Registry  |
            | Docker Hub / ECR     |
            +----------------------+
                     |
                     v
            +----------------------+
            | Deploy Stage         |
            | Deploy to Staging    |
            +----------------------+
                     |
                     v
            Staging Environment
```

---

# Challenge Task 5 – Explore in the Wild

## Selected Repository

Repository:

https://github.com/fastapi/fastapi

Workflow Folder:

```
.github/workflows/
```

Example Workflow:

```
tests.yml
```

### What triggers it?

- Push
- Pull Request

---

### How many jobs does it have?

Multiple jobs (such as tests on different Python versions and operating systems).

---

### What does it do?

Best guess:

- Installs dependencies
- Sets up Python
- Runs automated tests
- Verifies the project builds correctly
- Ensures code changes don't break existing functionality

This helps maintain code quality before merging changes.

---

# Key Takeaways

- CI means automatically building and testing code.
- Continuous Delivery prepares software for deployment with manual approval.
- Continuous Deployment automatically releases software after successful testing.
- Pipelines automate repetitive development tasks.
- A failed pipeline is useful because it prevents broken code from reaching production.
- Automation improves speed, consistency, and reliability.

---

# Quick Revision

### CI

- Integrate code frequently
- Run builds
- Run tests
- Detect bugs early

---

### Continuous Delivery

- Everything in CI
- Package application
- Ready for deployment
- Manual approval required

---

### Continuous Deployment

- Everything in Continuous Delivery
- Automatic deployment
- No manual approval
- Faster software releases

---

# Interview Questions

### What is CI?

Continuous Integration is the practice of automatically building and testing code whenever changes are committed to a shared repository.

---

### What is Continuous Delivery?

Continuous Delivery automatically prepares software for deployment while requiring manual approval before production deployment.

---

### What is Continuous Deployment?

Continuous Deployment automatically deploys successful changes to production without manual intervention.

---

### What is a pipeline?

A pipeline is an automated workflow that builds, tests, packages, and deploys software.

---

### What is a runner?

A runner is the machine or agent that executes CI/CD pipeline jobs.

---

### What is an artifact?

An artifact is an output generated during a pipeline, such as build files, Docker images, logs, or test reports.

---

### Why is CI/CD important?

CI/CD improves software quality, reduces manual work, catches bugs early, enables faster releases, and ensures reliable deployments.

---

# References

- GitHub Actions Documentation
- Jenkins Documentation
- GitLab CI/CD Documentation
- Docker Documentation

---

# Completed Outputs

- ✅ CI/CD Concepts
- ✅ CI vs Continuous Delivery vs Continuous Deployment
- ✅ Pipeline Anatomy
- ✅ Pipeline Diagram
- ✅ Open Source Repository Analysis
- ✅ Interview Notes
- ✅ Quick Revision

---

**Day 39 Complete ✅**