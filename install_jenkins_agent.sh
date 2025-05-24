#!/bin/bash

#resize disk from 20GB to 50GB
growpart /dev/nvme0n1 4
lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol
xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

# Java-17 openjdk installation
yum install fontconfig java-17-openjdk -y

#This repository We are using for Jenkins only. So not below installation steps.
# #Installing Terraform on Jenkins Agent
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

# #Node JS installation
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

# #Installing zip in Jenins Agent
yum install zip -y


# # docker
# yum install -y yum-utils
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# systemctl start docker
# systemctl enable docker
# usermod -aG docker ec2-user