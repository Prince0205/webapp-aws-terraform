#!/usr/bin/env bash
cd /home/ec2-user/
echo "*****************CONFIGURE OS*****************"
#sudo hostnamectl set-hostname nat-server
sudo hostname nat-server
echo "New hostname is: $(hostname -f)"
hostname -f
echo "*****************DONE CONFIGURATION NAT-SERVER*****************"


sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins
sudo ls -lart /home/ec2-users/.ssh/

sudo echo "10.0.0.100 web" >> /etc/hosts
sudo echo "10.0.1.100 db" >> /etc/hosts

echo "*****************EPEL RELEASE*****************"
sudo yum -y install wget telnet
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
sudo rpm -ivh epel-release-7-10.noarch.rpm
sudo yum -y install epel-release
sudo yum -y update
sudo rm -rf epel-release-7-10.noarch.rpm
cd /home/ec2-user/
echo "*****************DONE EPEL*****************"

sudo ssh-keyscan web >> ~/.ssh/known_hosts
sudo ssh-keyscan db >> ~/.ssh/known_hosts

echo "*****************ANSIBLE*****************"
sudo yum -y install gcc
sudo yum -y install python-setuptools
sudo yum -y install python-devel
sudo easy_install pip
sudo pip install ansible
echo "$(ansible --version)"

sudo mkdir /etc/ansible/
sudo mv /home/ec2-user/ansible/ansible.cfg /etc/ansible/
sudo mv /home/ec2-user/ansible/hosts /etc/ansible/
ls -lart $HOME/ansible
echo "*****************FINISH ANSIBLE*****************"