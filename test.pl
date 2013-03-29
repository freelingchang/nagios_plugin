#!/usr/bin/perl -w
use Getopt::Long;
use strict;
my $PORT="232";
my $sysfile="/etc/redis/redis-$PORT.conf";
my $binfile="/usr/local/bin/redis-server";
my $datadir="/data/redis-$PORT";
my $pidfile="/var/run/redis-$PORT.pid";
my ($m,$p,$MEM);
GetOptions(
	'm=s' => \$MEM,
	'p=s' => \$PORT,
);
if ( ! system "lsof -i:$PORT"){;
	print "The port is uesd!\n";	
	exit 1;
}
if ( -e $sysfile ){
    print "The port used by $sysfile!";
    exit 1;
}
if ( ! -x $binfile ){
    print "The redis-server is not exits or Permission denied!";
    exit 1;
}
if ( ! -e $datadir ){
    mkdir  $datadir;
}
#print "$MEM $PORT";
my @file;
open FILE,'<','/etc/redis/redis.conf';
		@file=<FILE>;
close FILE;
@file; 
my $file;
print $file;
print "~~~~~~~~~~~~~~~~~~";
#$file=~ s/\$PORT/$PORT/g;
#print $file;

