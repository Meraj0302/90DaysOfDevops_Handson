# Day 08 – Cloud Server Setup: Docker, Nginx & Web Deployment

## Overview

**Date:** 2026-05-27  
**Task:** Deploy a real web server on the cloud using AWS EC2, install Nginx, configure security groups, and manage logs.

---

## Part 1: Cloud Instance Launch & SSH Access

### Step 1: Create Cloud Instance (AWS EC2)

1. Logged into **AWS Console** → navigated to **EC2 Dashboard**
2. Clicked **"Launch Instance"**
3. Configured the instance:
   - **Name:** `devops-day08-server`
   - **AMI:** Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (Free Tier eligible)
   - **Instance type:** `t2.micro` (Free Tier eligible)
   - **Key pair:** Created a new key pair `devops-day08-key.pem` → downloaded it
   - **Security Group:** Created `devops-day08-sg` with inbound rules:
     - SSH (port 22) – My IP
     - HTTP (port 80) – Anywhere (0.0.0.0/0)
4. Clicked **"Launch Instance"** → waited ~1–2 minutes for it to reach **"Running"** state
5. Noted the **Public IPv4 address:** `13.233.xx.xx`

---

### Step 2: Connect via SSH

```bash
# Set correct permissions on key file (required on Linux/Mac)
chmod 400 devops-day08-key.pem

# Connect to EC2 instance
ssh -i devops-day08-key.pem ubuntu@13.233.xx.xx
```

**Expected output:**
```
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 6.2.0-1012-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

ubuntu@ip-172-31-xx-xx:~$
```

> 📸 **Screenshot:** `ssh-connection.png` – Terminal showing successful SSH login

---

## Part 2: Install Docker & Nginx

### Step 1: Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

**Output snippet:**
```
Hit:1 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu jammy InRelease
Get:2 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu jammy-updates InRelease [119 kB]
...
Reading package lists... Done
Building dependency tree... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

---

### Step 2: Install Docker

```bash
# Install Docker dependencies
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add ubuntu user to docker group (avoid using sudo each time)
sudo usermod -aG docker ubuntu

# Verify Docker installation
docker --version
```

**Output:**
```
Docker version 26.1.4, build 5650f9b
```

---

### Step 3: Install Nginx

```bash
# Install Nginx directly on the server
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Verify Nginx is running
sudo systemctl status nginx
```

**Output:**
```
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2026-05-27 06:32:14 UTC; 15s ago
       Docs: man:nginx(8)
   Main PID: 1247 (nginx)
      Tasks: 2 (limit: 1141)
     Memory: 5.4M
        CPU: 19ms
     CGroup: /system.slice/nginx.service
             ├─1247 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             └─1248 nginx: worker process

May 27 06:32:14 ip-172-31-xx-xx systemd[1]: Starting A high performance web server...
May 27 06:32:14 ip-172-31-xx-xx systemd[1]: Started A high performance web server.
```

---

### Step 4: Run Nginx via Docker (Docker-Nginx)

```bash
# Pull official Nginx Docker image
docker pull nginx:latest

# Run Nginx container (map container port 80 to host port 8080)
docker run -d --name nginx-container -p 8080:80 nginx:latest

# Verify container is running
docker ps
```

**Output:**
```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                   NAMES
a3f2c1d89e01   nginx:latest   "/docker-entrypoint.…"   5 seconds ago   Up 4 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx-container
```

> 📸 **Screenshot:** `docker-nginx.png` – `docker ps` output showing running container

---

## Part 3: Security Group Configuration

### Inbound Rules Configured on AWS Console:

| Type  | Protocol | Port Range | Source          | Description          |
|-------|----------|------------|-----------------|----------------------|
| SSH   | TCP      | 22         | My IP           | SSH admin access     |
| HTTP  | TCP      | 80         | 0.0.0.0/0, ::/0 | Nginx web traffic    |
| HTTP  | TCP      | 8080       | 0.0.0.0/0, ::/0 | Docker Nginx traffic |

### Test Web Access

Opened browser and visited:
- `http://13.233.xx.xx` → ✅ Nginx Welcome Page visible
- `http://13.233.xx.xx:8080` → ✅ Docker Nginx Welcome Page visible

> 📸 **Screenshot:** `nginx-webpage.png` – Browser showing "Welcome to nginx!" page

---

## Part 4: Extract Nginx Logs

### Step 1: View Nginx Logs

```bash
# View access logs (live)
sudo cat /var/log/nginx/access.log

# View error logs
sudo cat /var/log/nginx/error.log

# Real-time log streaming
sudo tail -f /var/log/nginx/access.log
```

**Sample access log output:**
```
106.222.xx.xx - - [27/May/2026:06:45:12 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
106.222.xx.xx - - [27/May/2026:06:45:13 +0000] "GET /favicon.ico HTTP/1.1" 404 153 "http://13.233.xx.xx/" "Mozilla/5.0..."
```

---

### Step 2: Save Logs to File

```bash
# Save access logs
sudo cat /var/log/nginx/access.log > ~/nginx-logs.txt

# Append error logs with a separator
echo -e "\n--- ERROR LOGS ---\n" >> ~/nginx-logs.txt
sudo cat /var/log/nginx/error.log >> ~/nginx-logs.txt

# Confirm file was saved
ls -lh ~/nginx-logs.txt
cat ~/nginx-logs.txt
```

---

### Step 3: Download Log File to Local Machine

```bash
# On your LOCAL machine terminal (not the EC2 server)
# For AWS:
scp -i devops-day08-key.pem ubuntu@13.233.xx.xx:~/nginx-logs.txt .

# Verify download
ls -lh nginx-logs.txt
```

---

## Commands Used

```bash
# Permissions & SSH
chmod 400 devops-day08-key.pem
ssh -i devops-day08-key.pem ubuntu@<instance-ip>

# System update
sudo apt update && sudo apt upgrade -y

# Docker install
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ubuntu
docker --version

# Nginx install & management
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

# Docker + Nginx
docker pull nginx:latest
docker run -d --name nginx-container -p 8080:80 nginx:latest
docker ps

# Log management
sudo cat /var/log/nginx/access.log
sudo cat /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
sudo cat /var/log/nginx/access.log > ~/nginx-logs.txt
echo -e "\n--- ERROR LOGS ---\n" >> ~/nginx-logs.txt
sudo cat /var/log/nginx/error.log >> ~/nginx-logs.txt

# SCP download to local machine
scp -i devops-day08-key.pem ubuntu@<instance-ip>:~/nginx-logs.txt .
```

---

## Challenges Faced

| # | Challenge | Solution |
|---|-----------|----------|
| 1 | **SSH permission denied** – Got `WARNING: UNPROTECTED PRIVATE KEY FILE!` | Ran `chmod 400 devops-day08-key.pem` to fix key file permissions |
| 2 | **Port 80 not accessible** from browser | Added HTTP (port 80) inbound rule in AWS Security Group for `0.0.0.0/0` |
| 3 | **Docker: permission denied** on first `docker ps` run | Added user to docker group with `sudo usermod -aG docker ubuntu` and reconnected SSH |
| 4 | **Nginx not starting** – port 80 already in use | Checked with `sudo ss -tlnp \| grep :80` and found a conflicting process; killed it and restarted nginx |

---

## What I Learned

- **Cloud provisioning is straightforward** – AWS EC2 lets you spin up a server in under 2 minutes, but security groups are critical to control what traffic can actually reach it.
- **SSH key management matters** – File permissions on `.pem` keys are enforced for security reasons. `chmod 400` is mandatory before first use.
- **Nginx is lightweight and fast** – It starts instantly and serves a default page right out of the box, making it a great starting point for web deployments.
- **Docker adds portability** – Running Nginx in a Docker container means the same image works identically on any cloud or local machine.
- **Logs tell the full story** – Access logs show every request (IP, timestamp, status code, browser), which is essential for debugging and monitoring in production.
- **SCP is the simple file transfer tool** – It uses the same SSH key for authentication, making secure file downloads from remote servers easy and consistent.

---

## Why This Matters for DevOps

| Skill | How This Task Taught It |
|-------|------------------------|
| **Cloud infrastructure provisioning** | Launched and configured an EC2 instance from scratch |
| **Remote server management** | Used SSH for all server access and administration |
| **Service deployment** | Installed and ran Nginx both natively and via Docker |
| **Log management** | Extracted, saved, and downloaded server access logs |
| **Security** | Configured AWS Security Groups as a firewall |
| **Containerization** | Ran production web server inside a Docker container |

---

## Architecture Diagram

```
[Developer Laptop]
      │
      │  SSH (port 22) – admin access
      │  SCP (port 22) – file transfer
      ▼
[AWS EC2 – Ubuntu 22.04]
  Public IP: 13.233.xx.xx
      │
      ├── Nginx (native) → Port 80  ← HTTP traffic from internet
      │        │
      │        └── /var/log/nginx/access.log
      │
      └── Docker Container (nginx:latest) → Port 8080
```

---

*Submitted as part of #90DaysOfDevOps – Day 08*  
*Hashtags: #90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham*