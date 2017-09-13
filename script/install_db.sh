#!/usr/bin/env bash
echo "*****************CONFIGURE OS*****************"
echo "Change hostname"
sudo hostnamectl set-hostname db-server
echo "New hostname is: $(hostnamectl status)"
echo "*****************DONE CONFIGURATION DB-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo chmod 600 ~/.ssh/jenkins

sudo echo "10.0.0.100	web-server	web" >> /etc/hosts
sudo echo "10.0.1.100	db-server	db" >> /etc/hosts
sudo echo "10.0.0.10	nat-server	nat" >> /etc/hosts

sudo ssh-keyscan -H web >> ~/.ssh/known_hosts
sudo ssh-keyscan -H db >> ~/.ssh/known_hosts
sudo ssh-keyscan -H nat >> ~/.ssh/known_hosts