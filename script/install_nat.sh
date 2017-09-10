echo "*****************EPEL RELEASE*****************"
sudo cd $HOME
echo "*****************FINISH EPEL RELEASE*****************"

echo "*****************CONFIGURE RHEL*****************"
sudo hostname nat-server
echo "New hostname is: $(hostname -f)"
echo "*****************DONE CONFIGURATION DB-SERVER*****************"

sudo chmod 666 /etc/hosts
sudo echo "10.0.0.100	web-server	web" >> /etc/hosts
sudo echo "10.0.1.100	db-server	db" >> /etc/hosts
sudo echo "10.0.0.10	nat-server	nat" >> /etc/hosts

sudo ssh-keyscan -H 10.0.0.100, web >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.1.100, db >> ~/.ssh/known_hosts
sudo ssh-keyscan -H 10.0.0.10, nat >> ~/.ssh/known_hosts

echo "*****************EPEL RELEASE*****************"
sudo yum -y install wget telnet git nmap zip unzip
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

# sudo usermod -a -G root jenkins
# sudo vi /etc/sysconfig/jenkins
# change JENKINS_LISTEN_ADDRESS="0.0.0.0"
# ssh-keyscan -H [hostname],[ip_address] >> ~/.ssh/known_hosts
# ssh -o StrictHostKeyChecking=no username@hostname.com
# sudo cat /etc/sudoers
# add jenkins user
# useradd myNewUser
# sudo myNewUser