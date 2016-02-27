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
	sudo cp ~/redis-3.0.6/src/redis-trib.rb /usr/local/bin/
	sudo chmod +x /usr/local/bin/redis-trib.rb
fi

echo "setting up redis cluster"
server_dir="/server"
if [ ! -e "$server_dir" ];then
    sudo mkdir "$server_dir"
fi

master1_dir="$server_dir/6379"
if [ ! -e "$master1_dir" ];then
	sudo mkdir "$master1_dir"
fi
master2_dir="$server_dir/6380"
if [ ! -e "$master2_dir" ];then
	sudo mkdir "$master2_dir"
fi
master3_dir="$server_dir/6381"
if [ ! -e "$master3_dir" ];then
	sudo mkdir "$master3_dir"
fi

slave1_dir="$server_dir/26379"
if [ ! -e "$slave1_dir" ];then
	sudo mkdir "$slave1_dir"
fi
slave2_dir="$server_dir/26380"
if [ ! -e "$slave2_dir" ];then
	sudo mkdir "$slave2_dir"
fi
slave3_dir="$server_dir/26381"
if [ ! -e "$slave3_dir" ];then
	sudo mkdir "$slave3_dir"
fi

echo "starting up master1"
cd "$master1_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/6379/redis.conf > redis.log &"
echo "starting up master2"
cd "$master2_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/6380/redis.conf > redis.log &"
echo "starting up master3"
cd "$master3_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/6381/redis.conf > redis.log &"
echo "starting up slave1"
cd "$slave1_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/26379/redis.conf > redis.log &"
echo "starting up slave2"
cd "$slave2_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/26380/redis.conf > redis.log &"
echo "starting up slave3"
cd "$slave3_dir"
sudo sh -c "/usr/local/bin/redis-server /vagrant/config/redis-cluster/26381/redis.conf > redis.log &"

echo "open port 6379 6380 16379 16380"
sudo firewall-cmd --permanent --add-port=6379/tcp
sudo firewall-cmd --permanent --add-port=6380/tcp
sudo firewall-cmd --permanent --add-port=26379/tcp
sudo firewall-cmd --permanent --add-port=26380/tcp
sudo firewall-cmd --reload

echo "installing ruby with yum"
wget
sudo yum install -y ruby

echo "installing gem-redis"
#sudo yum install -y wget
#wget https://rubygems.org/downloads/redis-3.2.2.gem
gem install -l /vagrant/redis*.gem

#echo "creating redis cluster"
#/usr/local/bin/redis-trib.rb create --replicas 1 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:26379 127.0.0.1:26380 127.0.0.1:26381

