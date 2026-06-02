# Day-03 Linux Command cheatsheet
---
# 1. Linux Process Management Command
Linux, process management involves **monitoring, controlling, and adjusting** the priority of running programs. Every process is assigned a unique Process ID (PID) used for identification
---

# Monitoring Processes Management Command:
- `top:` provide a real-time, dyanamic view of running processes, including CPU and Memory Usage.
    - Example: `top -b` (show in details)

- `htop:` An Interactive, more user-friendly version of **htop** that allows scrolling and easier process killing

- `ps:` Display a snapshot of currently running processess

- `ps -aux:` Show all processes for all users.

- `pstree:` Shows running processes as a tree diagram to illustrate parent-child relationships

- `pgrep:` Serch running process by name or pid
    - Example: **pgrep systemd**
- `pidof:` find the **PID** a specific running program.
    - Example: **pidof sh, pidof systemd, pidof cron**

---

# Terminating & Controlling Processes:
- `kill pid:` Sends a signal to SIGTERM to terminate a process by its PID.
    - Example: `kill 7768` (this Point it is ping pid)

- `killall name:` Terminates all processes that match a specific name.
    - Example: `killall firefox`

- `pkill name:` Send singnals to process based on name or other attributes.
    - Example: `pkill ping`

---
# Managing Process Priority
- `nice -n value command:` Starts a new process with a specific priority.
    - Example: `nice -n 10 ./backup_script.sh` (low priority)

- `renice` (**`renice -n value -p PID`**): Changes the priorty of an already running process.
    - Example: `sudo nice -n -5 ./heavy_task.sh` (High priority)

---

# Background & Foreground Jobs
- `&:` Adding this to the end of a command, runs it in the background.
    - Example: `command & or sudo apt update &`

- `jobs:` Lists background and suspended jobs in the current shell
        `jobs -l`	Lists process IDs (PIDs) alongside the job IDs and status.
    - Example:  
        - `jobs -r:` Displays only running background jobs.
        - `jobs -s:` Displays only stopped or suspended jobs.
        - `jobs -p:` Prints only the PIDs of the jobs.

- `fg:` Brings a background or stopped job to the foreground.
    
- `bg:` Resumes a stopped job in the background.

---

# Common Process Signals

When using kill, you can specify signals to dictate how the process should stop
- SIGTERM (15): The default signal to request a graceful termination.
- SIGKILL (9): Forcefully kills the process immediately.
- SIGSTOP (19): Pauses the process without terminating it.
- SIGCONT (18): Resumes a stopped process

---

# 2. File system

Linux file system commands are used to navigate, manage, and monitor the unified directory structure that starts from the root directory (/)

---

## Navigation and Exploration
These commands help you move through the directory tree and see where you are. 

- `pwd:` Prints the full path of your current working directory.
- `ls:` Lists files and directories in the current folder. Use `ls -l` for detailed information or `ls -a` to see hidden files.
- `cd:` Changes your current directory. Use `cd .. ` to go up one level or `cd ~ or cd` to return to your home directory.
- `tree:` Displays a visual tree structure of directories and files (require installation).

---

## File and Directory Management
Use these for basic operations like creating, moving, or deleting files and folders. 

- `touch:` Creates a new, empty file.
- `mkdir:` Creates a new directory.
- `cp:` Copies files or directories.
- `mv:` Moves or renames files and directories.
- `rm:` Deletes files. Use `rm -r` to delete a directory and its contents.
- `rmdir:` Deletes an empty directory.
- `cat:` Displays the contents of a file in the terminal
- `vi file:` Create file and edit with vi editior(vim)

---

## Disk and System Information
These commands provide technical details about the physical storage and the file system itself. 

- `df:` Shows the amount of disk space used and available on file systems. `df -h` Human readable
- `du:` Estimates file and directory space usage. `du -h` Human readable
- `lsblk:` Lists information about all available or specified block devices (disks and partitions).
- `mount / umount:` Attaches or detaches a file system to the main directory tree.

---

## Access and Permissions

- `chmod:` Changes the access permissions (read, write, execute) of a file or directory.
    - Example: chmod +x Execute to all, chmod 400 Read Only,  
- `chown:` Changes the owner and group of a file

| Permission | Symbol | Numeric | Symbolic |
| -------- | -------- | -------- | -------- |
| Read | -w- | 4 | r |
| Write | r-- | 2 | w |
| Execute | --x | 1 | x |

---

# 3. Networking troubleshooting

Network troubleshooting commands help diagnose and resolve connectivity, DNS, and configuration issues.
Run them directly from operating system's Linux Terminal.

---

## Basic Networking Commands 

- `ping destination:` Sends Packets to check connectivity
- `tracert destination:` Display path of every hop count from src to destination
- `ifconfig:` Shows network interfaces and IP addresses.
- `ip:` Moden replacement for ifconfig
- `nslookup domain:` Queries the Domain Name System(DNS) to find the IP address associated with a specific domain
- `dig domain:` Provides detailed, advanced DNS record information
- `netstat:` dispaly active network connections, routing tables, and interface statics.
- `telnet IP PORT:` Test if a specific port on a remote server (not secure)

