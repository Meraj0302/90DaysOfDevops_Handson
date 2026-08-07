# Day 37 – Docker Revision & Cheat Sheet

Goal: pause and consolidate Days 29–36 so Docker actually sticks.

---

## 1. Self-Assessment Checklist

| Skill | Status |
|---|---|
| Run a container from Docker Hub (interactive + detached) | ✅ |
| List, stop, remove containers and images | ✅ |
| Explain image layers and how caching works | ✅ |
| Write a Dockerfile from scratch (FROM, RUN, COPY, WORKDIR, CMD) | ✅ |
| Explain CMD vs ENTRYPOINT | ✅ |
| Build and tag a custom image | ✅ |
| Create and use named volumes | ✅ |
| Use bind mounts | ✅ |
| Create custom networks and connect containers | ✅ |
| Write a docker-compose.yml for a multi-container app | ✅ |
| Use environment variables and .env files in Compose | ✅ |
| Write a multi-stage Dockerfile | ✅ |
| Push an image to Docker Hub | ✅ |
| Use healthchecks and depends_on | ✅ |


---

## 2. Quick-Fire Questions — Answer From Memory First, Then Check Below


<details>
<summary>1. What is the difference between an image and a container?</summary>

An **image** is a read-only, layered template — the packaged filesystem + metadata (built from a Dockerfile). A **container** is a running (or stopped) instance of an image, with its own writable layer on top. One image can spin up many containers.
</details>

<details>
<summary>2. What happens to data inside a container when you remove it?</summary>

Any data written to the container's writable layer is lost permanently when the container is removed (`docker rm`). Only data stored in a **volume** or **bind mount** survives, because that data lives outside the container's own filesystem layer.
</details>

<details>
<summary>3. How do two containers on the same custom network communicate?</summary>

On a user-defined (custom) bridge network, Docker provides automatic DNS resolution by **container name** (or Compose service name). So one container can reach another simply by using its name as the hostname — no need to hardcode IPs, and no need to publish ports to the host for container-to-container traffic.
</details>

<details>
<summary>4. What does `docker compose down -v` do differently from `docker compose down`?</summary>

`docker compose down` stops and removes containers, networks, and default resources created by `up`, but **keeps named volumes**. Adding `-v` additionally removes those named volumes — meaning any persisted data (e.g., a database) is wiped too.
</details>

<details>
<summary>5. Why are multi-stage builds useful?</summary>

They let you use a heavier image (with compilers, build tools, dependencies) to **build** an app, then copy only the final artifacts into a slim runtime image. Result: smaller, more secure production images without the build-time bloat, and you avoid needing separate Dockerfiles for build vs. run.
</details>

<details>
<summary>6. What is the difference between `COPY` and `ADD`?</summary>

`COPY` does one thing: copies files/directories from the build context into the image. `ADD` does that too, but also **auto-extracts** local tar archives and can **fetch remote URLs**. Best practice: prefer `COPY` unless you specifically need ADD's extra behavior, since it's more predictable.
</details>

<details>
<summary>7. What does `-p 8080:80` mean?</summary>

It publishes/maps a port: `HOST_PORT:CONTAINER_PORT`. Traffic hitting port **8080 on the host machine** gets forwarded to port **80 inside the container**. The app inside still only needs to listen on 80.
</details>

<details>
<summary>8. How do you check how much disk space Docker is using?</summary>

`docker system df` — shows a summary of space used by images, containers, volumes, and build cache. Add `-v` (`docker system df -v`) for a detailed, per-item breakdown.
</details>

---

## 3. Cheat Sheet

See `docker-cheatsheet.md` — organized by Container / Image / Volume / Network / Compose / Cleanup commands, plus a Dockerfile instruction reference, a multi-stage build skeleton, and a Compose skeleton with env vars, volumes, networks, healthcheck, and depends_on.

---

## 4. Revisit Weak Spots

Pick the **2 topics** you marked 🟡 in the checklist above and redo the hands-on task from that day. Use this space to log what you did:

**Weak spot #1:** _______________________
- What I redid:
- What clicked this time:
- Still unclear:

**Weak spot #2:** _______________________
- What I redid:
- What clicked this time:
- Still unclear:

---
