#!/usr/bin/env bash
echo "*****************CONFIGURE OS*****************"
echo "Change hostname"
sudo hostnamectl set-hostname db-server
echo "New hostname is: $(hostnamectl status)"
echo "*****************DONE CONFIGURATION DB-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins

sudo echo "10.0.0.100 web" >> /etc/hosts
sudo echo "10.0.0.10 nat" >> /etc/hosts

sudo ssh-keyscan web >> ~/.ssh/known_hosts
sudo ssh-keyscan nat >> ~/.ssh/known_hosts