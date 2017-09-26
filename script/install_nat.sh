#!/usr/bin/env bash
cd /home/ec2-user/
echo "*****************CONFIGURE OS*****************"
sudo hostnamectl set-hostname nat-server
echo "New hostname is: $(hostname)"
echo "*****************DONE CONFIGURATION NAT-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins
ls -lart ~/.ssh/

echo "*****************EPEL RELEASE*****************"
sudo yum -y install wget telnet unzip dos2unix
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#sudo yum -y update
echo "*****************DONE EPEL*****************"

echo "*****************ANSIBLE*****************"
sudo yum -y install ansible
sudo mkdir /etc/ansible/
sudo mv /home/ec2-user/ansible/ansible.cfg /etc/ansible/
sudo mv /home/ec2-user/ansible/hosts /etc/ansible/
echo "*****************FINISH ANSIBLE*****************"

sudo echo "10.0.1.100 db" >> /etc/hosts
sudo echo "10.0.0.100 web" >> /etc/hosts

sudo ssh-keyscan web >> ~/.ssh/known_hosts
sudo ssh-keyscan db >> ~/.ssh/known_hosts