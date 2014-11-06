#!/usr/bin/perl
#Date  2013/3/7_1
#Author freelingchang@gmail.com
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
my $storagetype_table = '.1.3.6.1.2.1.25.2.3.1.2';
#如果设备类型为以下ID，则表示是一个分区
my $disktype='.1.3.6.1.2.1.25.2.1.4';
#储存单元大小列表
my $diskunits_table='.1.3.6.1.2.1.25.2.3.1.4';
#储存单元个数列表
my $OID_disknum_table = '.1.3.6.1.2.1.25.2.3.1.5';
#已使用储存单元数量列表
my $OID_used_num_table = '.1.3.6.1.2.1.25.2.3.1.6';
#最后一行的值=储存单元大小
#print $o_host;
#磁盘已使用大小=已使用储存单元个数*储存单元大小
#挂载点
my $OID_mount= '.1.3.6.1.2.1.25.2.3.1.3';
my $mount;
my ($session, $error) = Net::SNMP->session(
   -hostname  => $o_host,
   -version   => 2,
   -community => $o_community,
   -port      => 161,
   -timeout   => 5,
);

if (!defined $session) {
   printf "ERROR: %s.\n", $error;
   exit 3;
}

my $result = $session->get_table($OID_mem_all);
if (!defined $result) {
   printf "ERROR: %s.\n", $session->error();
   $session->close();
   exit 3;
}
#计算有几个分区
my $disk_n=0;
my @disk_id;
for my $char (keys %$result){
	if ("$$result{$char}" eq "$disktype"){
		push (@disk_id,"$char");
		$disk_n+=1;
	}
}
#print "显示所有符合的驱动器ID :@disk_id \n";
#print "有几个分区 :$disk_n \n";
##获取每个分区储存单元大小
my $i=1;
my $p=$disk_n+1;
my %disk_units=();
my @i;
for my $disk_t_n (@disk_id){
		$disk_t_n=~ /1.3.6.1.2.1.25.2.3.1.2.(.*)/;
		my $g=$1;
		push(@i,$g);
		#print "$g\n";
}
#print @i;
my $n=@i;
#print "显示所有驱动器ID后一位 @i";
#print  $$result{"$diskunits_table.$i"};
my %disk_num=();
my %disk_size=();
my %disk_use_num=();
my %disk_use_size=();
my %disk_use_percent=();
my %mount=();
my $status;
for $i (sort @i){
	#获取每个驱动器单元大小
    $disk_units{$i}=$$result{"$diskunits_table.$i"};
	#获取每个驱动器单元数量
	$disk_num{$i}=$$result{"$OID_disknum_table.$i"};
	#计算每个驱动器容量
	$disk_size{$i}=int($disk_units{$i}*$disk_num{$i}/1024/1024/1024);
	if ($disk_size{$i}==0){
		$disk_size{$i}=1;
	}
	#获取每个驱动器已使用单元数量
	$disk_use_num{$i}=$$result{"$OID_used_num_table.$i"};
	#计算每个驱动器已使用容量，单位为G
	$disk_use_size{$i}=int($disk_use_num{$i}*$disk_units{$i}/1024/1024/1024);
	#计算使用率百分比
	$disk_use_percent{$i}=int($disk_use_size{$i}/$disk_size{$i}*100);
	#获取挂载点
    if ($$result{"$OID_mount.$i"} eq '/mnt'){
        next;
    }
	$mount{$i}=$$result{"$OID_mount.$i"};
	$status=" OK";
	if ( $disk_use_percent{$i} > 95){
		$status=">95%% Waring!";
		print  "$mount{$i}:$disk_use_size{$i}G/$disk_size{$i}G $disk_use_percent{$i}%, ";
		print  "$status";
		exit 2;
	}
	print  "$mount{$i}:$disk_use_size{$i}G/$disk_size{$i}G $disk_use_percent{$i}%, ";
}

print  "$status";
exit 0;
