#!/bin/bash

/usr/local/bin/redis-server --version
if [ $? = 0 ];then
	echo "redis installed"
else
	echo "installing redis"
	cp /vagrant/redis-3.0.6.tar.gz ~/
	cd
	tar -xvzf redis-3.0.6.tar.gz
	cd redis-3.0.6
	make
	sudo make install
fi

echo "setting up redis master-slave"
server_dir="/server"
if [ ! -e "$server_dir" ];then
       sudo mkdir "$server_dir"
fi

master_dir="$server_dir/6379"
if [ ! -e "$master_dir" ];then
	sudo mkdir $master_dir
fi
slave_dir="$server_dir/6380"
if [ ! -e "$slave_dir" ];then
	sudo mkdir "$slave_dir"
fi
echo "starting up master"
cd "$master_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-standalone/6379-master/redis.conf > redis.log &"
#/usr/local/bin/redis-server /vagrant/config/redis-standalone/6379-master/redis.conf > redis.log &
echo "starting up slave"
cd "$slave_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-standalone/6380-slave/redis.conf > redis.log &"

echo "open port 6379 6380"
sudo firewall-cmd --permanent --add-port=6379/tcp
sudo firewall-cmd --permanent --add-port=6380/tcp
sudo firewall-cmd --reload
#/usr/local/bin/redis-server /vagrant/config/redis-standalone/6380-slave/redis.conf > redis.log &
#sudo redis-server &
