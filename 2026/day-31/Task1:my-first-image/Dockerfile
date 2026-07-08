#Base Image
FROM ubuntu:latest

#update and install curl in image
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

#Execute command
CMD ["echo", "Hello from my custom image!"]