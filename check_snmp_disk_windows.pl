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

#全部信息
my $OID_mem_all = '.1.3.6.1.2.1.25.2';
#储存设备类型列表
my $storagetype_table = '1.3.6.1.2.1.25.2.3.1.2';
#如果设备类型为以下ID，则表示是一个分区
my $disktype='1.3.6.1.2.1.25.2.1.4';
#储存单元大小列表
my $diskunits_table='.1.3.6.1.2.1.25.2.3.1.4';
#储存单元个数列表
my $OID_disknum_table = '1.3.6.1.2.1.25.2.3.1.5';
#已使用储存单元数量列表
my $OID_used_num_table = '1.3.6.1.2.1.25.2.3.1.6';
#最后一行的值=储存单元大小
#print $o_host;
#磁盘已使用大小=已使用储存单元个数*储存单元大小
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

my $result = $session->get_table($storagetype_table);
if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 2;
}
#计算有几个分区
my $disk_n=0;
for my $char (keys %$result){
	if ($$result{$char} eq $disktype){
		$disk_n+=1;
	}
}
#print "$disk_n \n";
##获取每个分区储存单元大小
my $i=1;
my $p=$disk_n+1;
my %disk_units=();
#print "$p \n";
$result = $session->get_table($diskunits_table);
if (!defined $result) {
printf "ERROR: %s.\n", $session->error();
$session->close();
exit 2;
}
for my $char (sort keys %$result){
	if ($i <= $disk_n){
    #print  ("$char=> $$result{$char}\n");
	$disk_units{$i}=$$result{"$diskunits_table.$i"};
	$i+=1;
	}
}
#for my $char (keys %disk_units){
#    print  ("$char=> $disk_units{$char}\n");
#}
##获取每个分区单元数量	
$i=1;
my %disk_num=();
$result = $session->get_table($OID_disknum_table);
if (!defined $result) {
printf "ERROR: %s.\n", $session->error();
$session->close();
exit 2;
}
for my $char (sort keys %$result){
	if ($i <= $disk_n){
    #print  ("$char=> $$result{$char}\n");
	$disk_num{$i}=$$result{"$OID_disknum_table.$i"};
	$i+=1;
	}
}
#for my $char (keys %disk_num){
#    print  ("$char=> $disk_num{$char}\n");
#}
####计算每个分区大小
$i=1;
my %disk_size=();
while ($i <=$disk_n){
	$disk_size{$i}=int($disk_units{$i}*$disk_num{$i}/1024/1024/1024);
	$i+=1;
}
#for my $char (keys %disk_size){
#    print  ("$char=> $disk_size{$char}\n");
#}
#	
##	print  ("$char=> $$result{$char}\n");
##}
##print $mem_all_h;
##计算每个分区已使用大小
my %disk_use_num=();
my %disk_use_size=();
$i=1;
$result = $session->get_table($OID_used_num_table);
if (!defined $result) {
printf "ERROR: %s.\n", $session->error();
$session->close();
exit 2;
}
for my $char (sort keys %$result){
	if ($i <= $disk_n){
    #print  ("$char=> $$result{$char}\n");
	$disk_use_num{$i}=$$result{"$OID_used_num_table.$i"};
	$i+=1;
	}
}
$i=1;
while ($i <=$disk_n){
	$disk_use_size{$i}=int($disk_use_num{$i}*$disk_units{$i}/1024/1024/1024);
	$i+=1;
}
#for my $char (keys %disk_use_size){
#    print  ("$char=> $disk_use_size{$char}\n");
#}
##输出盘符，已使用大小，总大小，百分比，加入性能参数
#计算使用百分比
my %disk_use_percent=();
$i=1;
while ($i <=$disk_n){
	$disk_use_percent{$i}=int($disk_use_size{$i}/$disk_size{$i}*100);
	$i+=1;
}
#for my $char (keys %disk_use_percent){
#	print ("$char => $disk_use_percent{$char}\n");
#}
$i=1;
my @panfu=("C".."Q");
while ($i <= $disk_n){
	print shift(@panfu);
	print " Used:";
	print "$disk_use_size{$i}G/";
	print "$disk_size{$i}G ";
	print "$disk_use_percent{$i}% ";
	$i+=1;
}
my $status;
for my $char (keys %disk_use_percent){
if ($disk_use_percent{$char} <85){
		print "OK";
		exit 0;
	}	
else{
	print "Waring";
	exit 1;
}
}
#if ( $mem_use_percent < 85){
#	 $status="<85%% ok";
#	 printf  "Used :%d MB/$mem_total_h MB %d%% $status\n", $mem_use,$mem_use_percent;
##	exit 0;
##}
##else {	
##$status=">85% warning!";
##printf  "Used :$mem_use MB/$mem_total_h MB  $status|mem_use=$mem_use_percent";
##exit 1;
##}
