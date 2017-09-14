#!/usr/bin/env bash
echo "*****************CONFIGURE OS*****************"
echo "Change hostname"
sudo hostnamectl set-hostname web-server
echo "New hostname is: $(hostnamectl status)"
echo "*****************DONE CONFIGURATION WEB-SERVER*****************"

sudo echo "10.0.1.100 db" >> /etc/hosts
sudo echo "10.0.0.10 nat" >> /etc/hosts

sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins

sudo ssh-keyscan db >> ~/.ssh/known_hosts
sudo ssh-keyscan nat >> ~/.ssh/known_hosts