#!/usr/bin/env bash
echo "*****************CONFIGURE RHEL*****************"
echo "Change hostname"
sudo hostnamectl set-hostname web-server
#sudo hostname web-server
echo "New hostname is: $(hostnamectl status)"
echo "*****************DONE CONFIGURATION WEB-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo chmod 400 ~/.ssh/jenkins

sudo echo "10.0.0.100	web-server	web" >> /etc/hosts
sudo echo "10.0.1.100	db-server	db" >> /etc/hosts
sudo echo "10.0.0.10	nat-server	nat" >> /etc/hosts

sudo ssh-keyscan -H 10.0.0.100, web >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.1.100, db >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.0.10, nat >> ~/.ssh/known_hosts

