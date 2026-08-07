# Docker Cheat Sheet

Quick, on-the-job reference. One line per command.

## Container Commands

| Command | What it does |
|---|---|
| `docker run IMAGE` | Run a new container (foreground) |
| `docker run -it IMAGE bash` | Run interactively with a terminal attached |
| `docker run -d IMAGE` | Run detached (background) |
| `docker run -d -p 8080:80 --name web IMAGE` | Run detached, map port, name it |
| `docker run --rm IMAGE` | Run and auto-remove container on exit |
| `docker ps` | List running containers |
| `docker ps -a` | List all containers (including stopped) |
| `docker stop CONTAINER` | Gracefully stop a container |
| `docker kill CONTAINER` | Force-stop a container immediately |
| `docker rm CONTAINER` | Remove a stopped container |
| `docker rm -f CONTAINER` | Force-remove a running container |
| `docker exec -it CONTAINER bash` | Open a shell inside a running container |
| `docker logs CONTAINER` | View container logs |
| `docker logs -f CONTAINER` | Follow (stream) container logs |
| `docker inspect CONTAINER` | Full JSON details of a container |
| `docker start CONTAINER` | Start a stopped container |
| `docker restart CONTAINER` | Restart a container |

## Image Commands

| Command | What it does |
|---|---|
| `docker build -t NAME:TAG .` | Build an image from a Dockerfile in current dir |
| `docker pull IMAGE:TAG` | Download an image from a registry |
| `docker push IMAGE:TAG` | Upload an image to a registry |
| `docker tag SOURCE_IMAGE NEW_NAME:TAG` | Create a new tag for an existing image |
| `docker images` / `docker image ls` | List local images |
| `docker rmi IMAGE` | Remove an image |
| `docker history IMAGE` | Show image layer history |

## Volume Commands

| Command | What it does |
|---|---|
| `docker volume create NAME` | Create a named volume |
| `docker volume ls` | List volumes |
| `docker volume inspect NAME` | Show volume details (mount point, etc.) |
| `docker volume rm NAME` | Remove a volume |
| `docker run -v NAME:/path IMAGE` | Mount a named volume into a container |
| `docker run -v $(pwd):/path IMAGE` | Bind mount current host dir into a container |

## Network Commands

| Command | What it does |
|---|---|
| `docker network create NAME` | Create a custom (bridge) network |
| `docker network ls` | List networks |
| `docker network inspect NAME` | Show network details (connected containers, subnet) |
| `docker network connect NETWORK CONTAINER` | Connect a running container to a network |
| `docker network disconnect NETWORK CONTAINER` | Disconnect a container from a network |
| `docker run --network NAME IMAGE` | Run a container attached to a specific network |

## Compose Commands

| Command | What it does |
|---|---|
| `docker compose up` | Create and start all services (foreground) |
| `docker compose up -d` | Start all services detached |
| `docker compose up --build` | Rebuild images before starting |
| `docker compose down` | Stop and remove containers/networks (keeps volumes) |
| `docker compose down -v` | Also remove named volumes |
| `docker compose ps` | List services and their status |
| `docker compose logs` | View logs for all services |
| `docker compose logs -f SERVICE` | Follow logs for one service |
| `docker compose build` | Build/rebuild images without starting |
| `docker compose exec SERVICE bash` | Shell into a running service container |
| `docker compose restart SERVICE` | Restart a single service |

## Cleanup Commands

| Command | What it does |
|---|---|
| `docker system df` | Show disk space used by images/containers/volumes |
| `docker system prune` | Remove unused containers, networks, dangling images |
| `docker system prune -a` | Also remove all unused images (not just dangling) |
| `docker container prune` | Remove all stopped containers |
| `docker image prune` | Remove dangling (untagged) images |
| `docker image prune -a` | Remove all unused images |
| `docker volume prune` | Remove unused volumes |
| `docker network prune` | Remove unused networks |

## Dockerfile Instructions

| Instruction | What it does |
|---|---|
| `FROM image:tag` | Base image to build on top of |
| `RUN command` | Execute a command at build time (new layer) |
| `COPY src dest` | Copy files from host into the image |
| `ADD src dest` | Like COPY, but also auto-extracts archives and fetches URLs |
| `WORKDIR /path` | Set the working directory for subsequent instructions |
| `EXPOSE port` | Document which port the container listens on (no publishing) |
| `ENV KEY=value` | Set an environment variable in the image |
| `ARG name=default` | Build-time variable (not present at runtime) |
| `CMD ["exec", "form"]` | Default command/args; overridden by `docker run` args |
| `ENTRYPOINT ["exec", "form"]` | Fixed executable; `docker run` args are appended to it |
| `USER name` | Set the user the container runs as |
| `VOLUME ["/path"]` | Declare a mount point |
| `HEALTHCHECK CMD command` | Command Docker runs to check container health |

## Multi-Stage Build Skeleton

```dockerfile
# Build stage
FROM node:20 AS build
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Final stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
```

## Compose Skeleton (with env, volumes, networks, healthcheck, depends_on)

```yaml
services:
  web:
    build: .
    ports:
      - "8080:80"
    env_file:
      - .env
    depends_on:
      db:
        condition: service_healthy
    networks:
      - appnet

  db:
    image: postgres:16
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 3s
      retries: 5
    networks:
      - appnet

volumes:
  db-data:

networks:
  appnet:
```