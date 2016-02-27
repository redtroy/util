#!/bin/bash
wget -V
if [ $? = 0 ];then
	echo "wget installed"
else
	echo "installing wget using yum"
	sudo yum install -y wget
fi

java -version
if [ $? = 0 ];then
	echo "java installed"
else
	echo "installing java from /vagrant"
	sudo rpm -ivh /vagrant/jdk*.rpm
fi

tomcat_dir="/server/"

#check if directory exists
if [ ! -e "$tomcat_dir" ];then
	sudo mkdir "$tomcat_dir"
	echo "installing tomcat into /server"
	sudo tar -xvzf /vagrant/apache-tomcat-8.0.30.tar.gz -C "$tomcat_dir"
fi
echo "Provision DONE!"
#echo "installing tomcat in /server"
#sudo tar -xvzf /vagrant/apache-tomcat-8.0.30.tar.gz -C "$tomcat_dir"


