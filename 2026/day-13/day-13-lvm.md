# Day 13 – Linux Volume Management (LVM)

## I'm doing this assignment using ec2 instance
![alt text](<Screenshot 2026-06-09 160234.png>)

# Task 1: Check Current Storage
## Here, I have created few volume/storage.
![alt text](<Screenshot 2026-06-09 160311.png>)

## Attached all volume to EC2 instance
![alt text](<Screenshot 2026-06-09 162026.png>)

# Task 2: Create Physical Volume
## now i created physical volume
![alt text](image.png)

# Task 3: Create Volume Group
## vloume group being created using `vgcreate`
![alt text](image-1.png)

# Task 4: Create Logical Volume
## logical volume being created using 
`mkfs.ext4 /dev/devops-vg/app-data`
`mkdir -p /mnt/app-data`
`mount /dev/devops-vg/app-data /mnt/app-data`
`df -h /mnt/app-data`
![alt text](image-2.png)
![alt text](<Screenshot 2026-06-09 163834.png>)

# Task 5: Format and Mount
## logical Volume now mounting to /mnt
![alt text](<Screenshot 2026-06-09 163954.png>)

# Task 6: Extend the Volume
## Extend the volume using `lvextend -L +200M /dev/devops-vg/app-data`, `resize2fs /dev/devops-vg/app-data`, `df -h /mnt/app-data`
