# Runbook assingment over SSH

### Troubleshooting steps for ssh if it goes down

# Enviroment basics:

### command `uname -a`
## Output:
![alt text](image.png)

### command `lsb_release -a`
## Output:
![alt text](image-1.png)

### command `cat /et/os-release`
## Output:
![alt text](image-2.png)

# Filesystem sanity:

### Step1: Create dir = `mkdir /tmp/runbook-demo`
### Step2: Copy Host file to path=`/tmp/runbook-demo`
### Step3: list the Copy host file or can we read that host file without touch main file.

## Output
![alt text](image-3.png)

# CPU / Memory

### for checking running process of RAM & CPU:
- Command: `top`, `htop`

### Output of first 10 Lines `top` command:
![alt text](image-5.png)

## Output of first 10 Lines `htop` command, before run htop need to install it in linux and press q for exit:
![alt text](image-4.png)

### Taking snapshot of memory, cpu, RAM etc:
## Output of Command `ps -o pid`, `ps -o pcpu`, `ps -o pmem`:
![alt text](image-6.png)

# Disk / IO

### Disk Usage and Input/Output Statistics(iostat), Virtual Memory Statistics(vmstat), and real-time system resource monitoring (dstat)

## Output of `df -h` `du -sh /var/log` `iostat` `vmstat` `dstat`
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)

# Network
### Few networking Command that is showing system information about network bandwidth and interface configuration

## Output of Command `ss -tulpn/netstat`, `curl -I <service-endpoint>`, `ping`
![alt text](image-12.png)
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)

# Logs

### Here is few command that will help to find out service logs `journalctl -u <service> -n 50, tail -n 50 /var/log/<file>.log`

## Output
![alt text](image-17.png)
![alt text](image-18.png)