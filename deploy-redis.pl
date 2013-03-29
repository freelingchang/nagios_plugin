#!/usr/bin/perl
$binfile=/usr/local/bin/redis-server
$datadir=/data/redis-$PORT
$pidfile=/var/run/redis-$PORT.pid
$sysfile=/etc/redis/redis-$PORT.conf
system 'lsof' '-i:$PORT' && print "The port is uesd!" &&	exit 1
if [ -f $sysfile ];then
	echo "The port used by $sysfile!"
s	exit 1
fi
if [ ! -x $binfile ];then
y	echo "The redis-server is not exits or Permission denied!"
	exit 1
fi

if [ ! -d $datadir ];then
	mkdir -p $datadir
fi
cp -p /etc/redis/redis.conf  /etc/redis/redis-$PORT.conf
sed -i "s/\$PORT/$PORT/g"  /etc/redis/redis-$PORT.conf
sed -i "s/\$MEM/$MEM/g"  /etc/redis/redis-$PORT.conf
