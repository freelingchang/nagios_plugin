#!/usr/bin/python
# -*- coding: utf-8 -*-
file=open('./status.dat')
str=file.read()
file.close
import re
#print str
#把包servicestatus{}字段提取出来
pat=re.compile(r"servicestatus {(.*?)}",re.S)
#提取主机名
host=re.compile(r"host_name=(.*)")
#service=re.compile(r"service_description=(.*)")
#service_all_info = pat.findall(str)
#match = pat.match(str)
#if match:
#	for str in match:
#		hostname=host.search(str)
#		servicename=service.search(str)
#		print hostname.group(1)
#		print servicename.group(1)

#hostname=host.search(service_all_info[0])
#servicename=service.search(service_all_info[0])
#service_m=servicename.group(1)
#把包servicestatus{}字段提取出来
s=re.compile(r"servicestatus {(.*?)}",re.S)
#ss=re.compile(r"servicestatus {(.*?)%s(.*?)}"%(check_command),re.S)
#把{}包chech_command字段提取出来
ss=re.compile(r".*check_command=(.*?)\n",re.S)
#ss=re.compile(r".*check_command=check_snmp_cpu_load\n.*",re.S)
#ss=re.compile(r"%s"%(service_m),re.S)

#ss=re.compile(r"servicestatus {(.*?)"+service_m+"(.*?)}",re.S)
service_data=s.findall(str)
#提取所有要检测的服务名称
service_dict={}
if service_data:
	for a_service in service_data:
		service_name=ss.match(a_service)
		check_name=service_name.group(1)
		service_dict[check_name]=1
		#print check_name
#		if name_s:
#			print name_s.group()
		#for stttr in name_s:
	#		s_hostname=host.search(stttr)
	#		print s_hostname
	#		for stttr in sttr:
	###sttr中包含了一个主机服务定义段
	#		name_s=host.search(stttr)
		#	print name_s.group(1)
for check_command in service_dict.keys():
	print check_command
	sss=re.compile(r"servicestatus {(.*?)%s.*}"%(check_command),re.S)
	service_data_cmd=sss.findall(str)
#	print check_command
#	print "~~~~~~~~~~~~~"
	if service_data_cmd:
		for a_service in service_data_cmd:
			print a_service
			hostname=host.search(a_service)
			#print "%s ==>%s" %(check_command,hostname.group())
			#print "!!!!!!!!!!"
		
