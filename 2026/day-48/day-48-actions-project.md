# Day 48 -- GitHub Actions Capstone Project

## Project Goal

Build a complete GitHub Actions CI/CD pipeline for a small Flask
application.

The pipeline will demonstrate:

-   Reusable GitHub Actions workflows
-   Pull Request CI
-   Main branch CI/CD
-   Docker image build and push
-   Production deployment flow
-   Scheduled Docker health checks
-   GitHub Actions job summaries
-   Workflow status badges
-   Production environment protection

------------------------------------------------------------------------

## 1. Project Structure

Use this repository structure:

``` text
github-actions-capstone/
├── .github/
│   └── workflows/
│       ├── reusable-build-test.yml
│       ├── reusable-docker.yml
│       ├── pr-pipeline.yml
│       ├── main-pipeline.yml
│       └── health-check.yml
├── app.py
├── requirements.txt
├── test_app.py
├── Dockerfile
├── .dockerignore
└── README.md
```

------------------------------------------------------------------------

# 2. Simple Flask Application

## `app.py`

``` python
from flask import Flask, render_template
app = Flask(__name__)


@app.route('/')
def hello_world():
    return render_template('index.html')


@app.route('/health')
def health():
    return 'Server is up and running'

```

The `/health` endpoint will be used by the scheduled health-check
workflow.

------------------------------------------------------------------------

# 3. Python Dependencies

## `requirements.txt`

``` text
flask==3.1.1
Werkzeug==3.1.3
pytest
```

------------------------------------------------------------------------

# 4. Basic Application Test

## `test_app.py`

``` python
import pytest
from app import app


@pytest.fixture
def client():
    app.config['TESTING'] = True

    with app.test_client() as client:
        yield client


def test_home_page(client):
    response = client.get('/')

    assert response.status_code == 200


def test_health_endpoint(client):
    response = client.get('/health')

    assert response.status_code == 200
    assert response.data == b'Server is up and running'
```

Run locally:

``` bash
pip install -r requirements.txt
pytest -v
```

Expected result:

``` text
2 passed
```

------------------------------------------------------------------------

# 5. Dockerfile

## `Dockerfile`

``` dockerfile
# Base image (OS)
FROM python:3.14-slim

# Working directory
WORKDIR /app

# Copy src code to container
COPY . .

# Run the build commands
RUN pip install --no-cache-dir -r requirements.txt

# expose port 80
EXPOSE 80

# serve the app / run the app (keep it running)
CMD ["python","run.py"]

```

------------------------------------------------------------------------

# 6. Docker Ignore

## `.dockerignore`

``` text
.git
.github
__pycache__
*.pyc
.pytest_cache
.env
.venv
venv
README.md
```

------------------------------------------------------------------------

# 7. Reusable Build & Test Workflow

## `.github/workflows/reusable-build-test.yml`

``` yaml
name: Reusable Build and Test

on:
  workflow_call:
    inputs:
      python_version:
        description: "Python version"
        required: false
        type: string
        default: "3.12"

      run_tests:
        description: "Run application tests"
        required: false
        type: boolean
        default: true

    outputs:
      test_result:
        description: "Result of the test step"
        value: ${{ jobs.build-test.outputs.test_result }}

jobs:
  build-test:
    runs-on: ubuntu-latest

    outputs:
      test_result: ${{ steps.test.outputs.test_result }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ inputs.python_version }}

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run tests
        id: test
        if: ${{ inputs.run_tests }}
        shell: bash
        run: |
          set +e

          pytest -v
          TEST_EXIT_CODE=$?

          if [ "$TEST_EXIT_CODE" -eq 0 ]; then
            echo "test_result=passed" >> "$GITHUB_OUTPUT"
          else
            echo "test_result=failed" >> "$GITHUB_OUTPUT"
            exit "$TEST_EXIT_CODE"
          fi

      - name: Tests skipped
        if: ${{ !inputs.run_tests }}
        run: |
          echo "test_result=passed" >> "$GITHUB_OUTPUT"
```

### Important concept

This workflow is reusable because it uses:

``` yaml
on:
  workflow_call:
```

It does not deploy anything and does not build or push Docker images.

------------------------------------------------------------------------

# 8. Reusable Docker Build & Push Workflow

## `.github/workflows/reusable-docker.yml`

``` yaml
name: Reusable Docker Build and Push

on:
  workflow_call:
    inputs:
      image_name:
        description: "Docker image name"
        required: true
        type: string

      tag:
        description: "Comma-separated Docker tags"
        required: true
        type: string

    secrets:
      docker_username:
        required: true

      docker_token:
        required: true

    outputs:
      image_url:
        description: "Full Docker image path"
        value: ${{ jobs.docker.outputs.image_url }}

jobs:
  docker:
    runs-on: ubuntu-latest

    outputs:
      image_url: ${{ steps.image.outputs.image_url }}

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v4
        with:
          logout: true
          username: ${{ vars.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Prepare Docker tags
        id: tags
        shell: bash
        env:
          IMAGE_NAME: ${{ inputs.image_name }}
          TAGS: ${{ inputs.tag }}
        run: |
          {
            echo "tags<<EOF"
            IFS=',' read -ra TAG_ARRAY <<< "$TAGS"

            for tag in "${TAG_ARRAY[@]}"; do
              echo "${IMAGE_NAME}:$(echo "$tag" | xargs)"
            done

            echo "EOF"
          } >> "$GITHUB_OUTPUT"

      - name: Build and push Docker image
        uses: docker/build-push-action@v7
        with:
          context: .
          push: true
          tags: ${{ steps.tags.outputs.tags }}

      - name: Set image output
        id: image
        shell: bash
        env:
          IMAGE_NAME: ${{ inputs.image_name }}
          TAGS: ${{ inputs.tag }}
        run: |
          FIRST_TAG=$(echo "$TAGS" | cut -d',' -f1 | xargs)
          echo "image_url=${IMAGE_NAME}:${FIRST_TAG}" >> "$GITHUB_OUTPUT"
```

### Why comma-separated tags?

The main pipeline needs two tags:

``` text
latest
sha-xxxxxxx
```

The reusable workflow accepts:

``` text
latest,sha-xxxxxxx
```

and converts them into valid Docker image tags.

------------------------------------------------------------------------

# 9. Pull Request Pipeline

## `.github/workflows/pr-pipeline.yml`

``` yaml
name: PR Pipeline

on:
  pull_request:
    branches:
      - main
    types:
      - opened
      - synchronize

permissions:
  contents: read

jobs:
  build-test:
    name: Build and Test
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: "3.12"
      run_tests: true

  pr-comment:
    name: PR Checks Summary
    needs: build-test
    runs-on: ubuntu-latest

    steps:
      - name: Print PR summary
        run: |
          echo "PR checks passed for branch: ${{ github.head_ref }}"
          echo "Test result: ${{ needs.build-test.outputs.test_result }}"
```

### PR behavior

``` text
Developer opens PR
        |
        v
PR Pipeline
        |
        v
Reusable Build & Test
        |
        v
Run pytest
        |
        v
PR checks summary
```

There is intentionally no Docker build or Docker push in this workflow.

------------------------------------------------------------------------

# 10. Main Branch Pipeline

## `.github/workflows/main-pipeline.yml`

``` yaml
name: Main CI/CD Pipeline

on:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  build-test:
    name: Build and Test
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      python_version: "3.12"
      run_tests: true

  docker:
    name: Build and Push Docker Image
    needs: build-test
    uses: ./.github/workflows/reusable-docker.yml
    with:
      image_name: ${{ vars.DOCKERHUB_USERNAME }}/github-actions-capstone
      tag: latest,sha-${{ github.sha }}
    secrets:
      docker_username: ${{ vars.DOCKERHUB_USERNAME }}
      docker_token: ${{ secrets.DOCKER_TOKEN}}

  deploy:
    name: Deploy to Production
    needs: docker
    runs-on: ubuntu-latest
    environment:
      name: production

    steps:
      - name: Deploy image
        run: |
          echo "Deploying image: ${{ needs.docker.outputs.image_url }} to production"

      - name: Deployment summary
        run: |
          echo "## Production Deployment" >> "$GITHUB_STEP_SUMMARY"
          echo "- Image: ${{ needs.docker.outputs.image_url }}" >> "$GITHUB_STEP_SUMMARY"
          echo "- Environment: production" >> "$GITHUB_STEP_SUMMARY"
          echo "- Status: DEPLOYED" >> "$GITHUB_STEP_SUMMARY"
          echo "- Commit: ${{ github.sha }}" >> "$GITHUB_STEP_SUMMARY"
```

## Pipeline dependency

The important part is:

``` yaml
needs: build-test
```

and:

``` yaml
needs: docker
```

Therefore the sequence is:

``` text
Build & Test
     |
     v
Docker Build & Push
     |
     v
Production Deploy
```

------------------------------------------------------------------------

# 11. Docker Image Tags

After a successful push, Docker Hub will contain:

``` text
meraj0302/github-actions-capstone:latest
```

and:

``` text
meraj0302/github-actions-capstone:sha-xxxxxx
```

Using the full SHA is still unique and immutable, even though the
assignment's hint mentions a 7-character short SHA.

change the `tag:` value in the caller to use a shell-generated value, or
add a small metadata job before the reusable Docker workflow. The
full-SHA version above is simpler and avoids relying on shell
substitution inside workflow inputs.

------------------------------------------------------------------------

# 12. Scheduled Health Check

## `.github/workflows/health-check.yml`

``` yaml
name: Scheduled Health Check

on:
  schedule:
    - cron: "0 */12 * * *"

  workflow_dispatch:

permissions:
  contents: read

jobs:
  health-check:
    name: Docker Health Check
    runs-on: ubuntu-latest

    steps:
      - name: Pull latest Docker image
        env:
          IMAGE_NAME: ${{ vars.DOCKERHUB_USERNAME }}/github-actions-capstone
        run: |
          docker pull "${IMAGE_NAME}:latest"

      - name: Start container
        env:
          IMAGE_NAME: ${{ vars.DOCKERHUB_USERNAME }}/github-actions-capstone
        run: |
          docker run -d \
            --name capstone-health-check \
            -p 80:80 \
            "${IMAGE_NAME}:latest"

      - name: Wait for application
        run: |
          sleep 5

      - name: Check health endpoint
        id: health
        shell: bash
        run: |
          set +e

          curl --fail --silent --show-error \
            http://0.0.0.0:80/health

          CURL_EXIT_CODE=$?

          if [ "$CURL_EXIT_CODE" -eq 0 ]; then
            echo "status=PASSED" >> "$GITHUB_OUTPUT"
          else
            echo "status=FAILED" >> "$GITHUB_OUTPUT"
          fi

          exit "$CURL_EXIT_CODE"

      - name: Create health-check summary
        if: always()
        env:
          IMAGE_NAME: ${{ vars.DOCKERHUB_USERNAME }}/github-actions-capstone
          HEALTH_STATUS: ${{ steps.health.outputs.status }}
        run: |
          echo "## Health Check Report" >> "$GITHUB_STEP_SUMMARY"
          echo "- Image: ${IMAGE_NAME}:latest" >> "$GITHUB_STEP_SUMMARY"
          echo "- Status: ${HEALTH_STATUS:-FAILED}" >> "$GITHUB_STEP_SUMMARY"
          echo "- Time: $(date)" >> "$GITHUB_STEP_SUMMARY"

      - name: Stop and remove container
        if: always()
        run: |
          docker rm -f capstone-health-check || true
```

The workflow runs:

``` text
Every 12 hours
      |
      v
Pull Docker image
      |
      v
Start container
      |
      v
Wait 5 seconds
      |
      v
curl /health
      |
      v
PASS / FAIL
      |
      v
Create GitHub summary
      |
      v
Remove container
```
------------------------------------------------------------------------

Then make production deployment depend on both Docker build and the
security scan:

``` yaml
  deploy:
    name: Deploy to Production
    needs:
      - docker
      - security-scan
    runs-on: ubuntu-latest
    environment:
      name: production

    steps:
      - name: Deploy image
        run: |
          echo "Deploying image: ${{ needs.docker.outputs.image_url }} to production"
```

This creates:

``` text
Build & Test
     |
     v
Docker Build & Push
     |
     +----------------+
     |                |
     v                v
Trivy Scan       Docker Image
     |                |
     +-------+--------+
             |
             v
        Production
```

If the critical vulnerability scan fails, deployment does not continue.

------------------------------------------------------------------------

# 13. GitHub Secrets and Variables

Go to:

``` text
Repository
  → Settings
  → Secrets and variables
  → Actions
```

Create these repository variables:

``` text
DOCKERHUB_USERNAME = your-dockerhub-username
```

Create these repository secrets:

``` text
DOCKERHUB_USERNAME = your-dockerhub-username
DOCKER_TOKEN    = your-dockerhub-access-token
```

The username is technically duplicated because reusable workflows
receive it as a secret while the image name uses it as a variable.

------------------------------------------------------------------------

# 14. Production Environment

Go to:

``` text
Repository
  → Settings
  → Environments
  → New environment
```

Create:

``` text
production
```

For manual approval:

``` text
production
    ↓
Deployment protection rules
    ↓
Required reviewers
    ↓
Add reviewer
```

Now the deploy job pauses until an authorized reviewer approves the
deployment.

------------------------------------------------------------------------