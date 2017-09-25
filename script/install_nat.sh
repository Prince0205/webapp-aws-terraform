#!/usr/bin/env bash
cd /home/ec2-user/
echo "*****************CONFIGURE OS*****************"
sudo hostname nat-server
echo "New hostname is: $(hostname)"
echo "*****************DONE CONFIGURATION NAT-SERVER*****************"

sudo chmod 600 ~/.ssh/jenkins
ls -lart ~/.ssh/

echo "*****************EPEL RELEASE*****************"
sudo yum -y install wget telnet
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
sudo rpm -ivh epel-release-7-10.noarch.rpm
sudo yum -y install epel-release
sudo yum -y update
sudo rm -rf epel-release-7-10.noarch.rpm
cd /home/ec2-user/
echo "*****************DONE EPEL*****************"

echo "*****************ANSIBLE*****************"
sudo yum -y install gcc
sudo yum -y install python-setuptools
sudo yum -y install python-devel
sudo easy_install pip
sudo pip install ansible

sudo mkdir /etc/ansible/
sudo mv /home/ec2-user/ansible/ansible.cfg /etc/ansible/
sudo mv /home/ec2-user/ansible/hosts /etc/ansible/
ls -lart $HOME/ansible
echo "*****************FINISH ANSIBLE*****************"

sudo ssh-keyscan web >> ~/.ssh/known_hosts
sudo ssh-keyscan db >> ~/.ssh/known_hosts