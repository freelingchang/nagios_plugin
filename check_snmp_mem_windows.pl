#!/usr/bin/perl
#date 2013/3/7_1
use strict;
use warnings;
use Net::SNMP;
use Getopt::Long;

my ( $o_host,$o_community);
GetOptions (
	'H=s' => \$o_host,
	'C=s' => \$o_community,
);

#my $o_host="192.168.1.38";
#my $o_community="sxmobi";
my $OID_mem_all = '.1.3.6.1.2.1.25.2';

#最后一行的值=储存单元使用个数
my $OID_mem_num = '.1.3.6.1.2.1.25.2.3.1.6';

#最后一行的值=储存单元大小
my $OID_mem_size = '.1.3.6.1.2.1.25.2.3.1.4';
#内存总大小
my $OID_mem_total = '.1.3.6.1.2.1.25.2.2.0';
#print $o_host;
#内存使用大小=已使用储存单元个数*储存单元大小
my ($session, $error) = Net::SNMP->session(
   -hostname  => $o_host,
   -version   => 2,
   -community => $o_community,
   -port      => 161,
   -timeout   => 5,
);

if (!defined $session) {
   printf "ERROR: %s.\n", $error;
   exit 2;
}

my $result = $session->get_table($OID_mem_all);
if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 2;
}
#for my $char (keys %$result){
#	print  ("$char=> $$result{$char}\n");
#}
my $mem_total=$$result{$OID_mem_total};
my $mem_total_h=$mem_total/1024;
$mem_total_h=int($mem_total_h);
#print $mem_all_h;
$result = $session->get_table($OID_mem_num);

if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 2;
}
my $OID_mem_num_big=0;
for my $char (keys %$result){
	if ($char=~ /.1.3.6.1.2.1.25.2.3.1.6.(.*)/){
		my $OID_mem_num_tmp=$1;
		if ($OID_mem_num_tmp >$OID_mem_num_big){
			$OID_mem_num_big=$OID_mem_num_tmp;
		}
	}
}
my $key_num=".1.3.6.1.2.1.25.2.3.1.6.$OID_mem_num_big";
#print $key;
my $mem_num=$$result{$key_num};
#print $mem_num;

$result = $session->get_table($OID_mem_size);

if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 2;
}
my $key_size=".1.3.6.1.2.1.25.2.3.1.4.$OID_mem_num_big";
my $mem_size=$$result{$key_size};
$session->close();
#print "mem_num is : $mem_num, mem_size is :$mem_size";
my $mem_use=$mem_num*$mem_size/1024/1024;
$mem_use=int($mem_use);
my $mem_use_percent=$mem_use/$mem_total_h*100;
my $status;
$mem_use_percent=int($mem_use_percent);
if ( $mem_use_percent < 85){
	 $status="<85%% ok";
	printf  "Used :%d MB/$mem_total_h MB %d%% $status\n", $mem_use,$mem_use_percent;
	exit 0;
}
else {	
$status=">85% warning!";
printf  "Used :$mem_use MB/$mem_total_h MB  $status|mem_use=$mem_use_percent";
exit 1;
}
#printf  "%d%% ", $mem_use_percent;
#	print ("$char=>$$result{$char}\n");
