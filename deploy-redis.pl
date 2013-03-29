#!/usr/bin/perl -w
use Getopt::Long;
use strict;
#my $PORT="232";
my ($m,$p,$MEM,$PORT);
GetOptions(
	'm=s' => \$MEM,
	'p=s' => \$PORT,
);
if ($PORT>65534 || $PORT<1024){
	print "pleaer set  1024<port<65534\n";
	exit 1;
} 
my $sysfile="/etc/redis/redis-$PORT.conf";
my $binfile="/usr/local/bin/redis-server";
my $datadir1="/data";
my $datadir="/data/redis-$PORT";
my $pidfile="/var/run/redis-$PORT.pid";
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
if ( ! -e $datadir1 ){
	mkdir $datadir1;
}
if ( ! -e $datadir ){
	mkdir $datadir;
}
#print "$MEM $PORT";
my $file;
open (FILE,'<','/etc/redis/redis.conf');
{
	local $/=undef;
		$file=<FILE>;
close FILE;
}
my @file;
@file=$file;
#print @file;
$file=~ s/\$PORT/$PORT/g;
$file=~ s/\$MEM/$MEM/g;
#print $file;


open (FILE,'>',"/etc/redis/redis-$PORT.conf");
	print FILE "$file";
close FILE;
exit 0;
