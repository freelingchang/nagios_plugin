#!/usr/bin/python
import netsnmp
sess = netsnmp.Session(Version=2, DestHost='127.0.0.1',Community='public')
#oid = netsnmp.Varbind('hrStorageDescr')
oid = netsnmp.Varbind('.1.3.6.1.2.1.25.2')
#oidList = netsnmp.VarList(oid)
oidlist=netsnmp.VarList(oid)
resultList = sess.walk(oidlist)
for str in resultList:
	print str
