#!/usr/bin/env bash
echo "*****************EPEL RELEASE*****************"
sudo cd $HOME/
echo "*****************FINISH EPEL RELEASE*****************"

echo "*****************CONFIGURE RHEL*****************"
sudo hostnamectl set-hostname nat-server
#sudo hostname nat-server
echo "New hostname is: $(hostname -f)"
echo "*****************DONE CONFIGURATION DB-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins

sudo echo "10.0.0.100 web-server web" >> /etc/hosts
sudo echo "10.0.1.100 db-server db" >> /etc/hosts
sudo echo "10.0.0.10 nat-server nat" >> /etc/hosts

sudo ssh-keyscan -H 10.0.0.100, web >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.1.100, db >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.0.10, nat >> ~/.ssh/known_hosts

echo "*****************EPEL RELEASE*****************"
sudo yum -y install wget telnet
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
sudo rpm -ivh epel-release-7-10.noarch.rpm
sudo yum -y install epel-release
sudo yum -y update
sudo rm -rf epel-release-7-10.noarch.rpm
sudo cd $HOME
echo "*****************DONE EPEL*****************"

echo "*****************ANSIBLE*****************"
sudo yum -y install gcc 
sudo yum -y install python-setuptools
sudo yum -y install python-devel
sudo easy_install pip
sudo pip install ansible
echo "$(ansible --version)"
echo "*****************FINISH ANSIBLE*****************"

#cd /home/ec2-user/webapp-aws-terraform/
#cp /home/ec2-user/.ssh/jenkins* script/
#terraform apply
#terraform output
#echo "Importing public IP addreses hosts file..."
#sudo echo "$(terraform output public_nat) nat-server nat" >> /etc/hosts
#sudo echo "$(terraform output public_web) nat-server nat" >> /etc/hosts
#echo "Importing DONE"