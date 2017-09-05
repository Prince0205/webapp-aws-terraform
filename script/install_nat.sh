echo "*****************EPEL RELEASE*****************"
sudo cd $HOME
echo "*****************FINISH EPEL RELEASE*****************"

echo "*****************CONFIGURE RHEL*****************"
sudo hostname nat-server
echo "New hostname is: $(hostname -f)"
echo "*****************DONE CONFIGURATION DB-SERVER*****************"

sudo ssh-keyscan -H 10.0.0.10 >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.0.100 >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.1.100 >> ~/.ssh/known_hosts

sudo chmod 666 /etc/hosts
sudo echo "10.0.0.100	web-server	web" >> /etc/hosts
sudo echo "10.0.1.100	db-server	db" >> /etc/hosts
sudo echo "10.0.0.10	nat-server	nat" >> /etc/hosts

sudo ssh-keyscan web >> ~/.ssh/known_hosts
sudo ssh-keyscan nat >> ~/.ssh/known_hosts
sudo ssh-keyscan db >> ~/.ssh/known_hosts

sudo ssh-keyscan 10.0.0.100 >> ~/.ssh/known_hosts
sudo ssh-keyscan 10.0.1.100 >> ~/.ssh/known_hosts
sudo ssh-keyscan 10.0.0.10 >> ~/.ssh/known_hosts


# sudo usermod -a -G root jenkins
# sudo vi /etc/sysconfig/jenkins
# change JENKINS_LISTEN_ADDRESS="0.0.0.0"
# ssh-keyscan -H [hostname],[ip_address] >> ~/.ssh/known_hosts
# ssh -o StrictHostKeyChecking=no username@hostname.com
# sudo cat /etc/sudoers
# add jenkins user
# useradd myNewUser
# sudo myNewUser