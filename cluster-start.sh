#!/bin/bash
/usr/local/bin/redis-trib.rb create --replicas 1 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 127.0.0.1:26379 127.0.0.1:26380 127.0.0.1:26381