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
sss=re.compile(r"servicestatus {(.*?)check_snmp_mem_linux.*?}",re.S)
service_data_cmd=sss.findall(str)
if service_data_cmd:
	print "!!!!!!!!!!"
	for s in service_data_cmd:
		print s
