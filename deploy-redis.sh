#!/bin/bash
set -x
binfile=/usr/local/bin/redis-server
while getopts p:m:h OPTION
do
	case $OPTION in
		m)MEM=$OPTARG;;
		p)PORT=$OPTARG;;
		h)echo '-p 指定端口号\n
				-m  指定内存大小';;
		*)echo "please enter ture optione"
			exit 1;;
	esac
done
datadir=/data/redis-$PORT
pidfile=/var/run/redis-$PORT.pid
sysfile=/etc/redis/redis-$PORT.conf
echo " $PORT  $MEM "
lsof -i:$PORT && echo "The port is uesd!" &&	exit 1
if [ -f $sysfile ];then
	echo "The port used by $sysfile!"
	exit 1
fi
if [ ! -x $binfile ];then
	echo "The redis-server is not exits or Permission denied!"
	exit 1
fi

if [ ! -d $datadir ];then
	mkdir -p $datadir
fi
cp -p /etc/redis/redis.conf  /etc/redis/redis-$PORT.conf
sed -i "s/\$PORT/$PORT/g"  /etc/redis/redis-$PORT.conf
sed -i "s/\$MEM/$MEM/g"  /etc/redis/redis-$PORT.conf
