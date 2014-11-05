#!/bin/python
#coding:utf-8
#Author:freelingchang@gmail.com
import os,sys
#想到一个新思路，完全没有必要设置间隔时间，只要对比mtime和now time时间戳即可
time=10
#因为cpu时间统计单位为100ms，所以要多除以10
once=time*10
cache_path=os.path.split(os.path.realpath(__file__))[0]
cache_file=cache_path+'/cpu_count.db'
f = open('/proc/stat','r')
status_now=f.readline().strip()
status_now_list = status_now.split()
cpu_idle_now=int(status_now_list[4])
cpu_iowait_now=int(status_now_list[5])
f.close()
if not  os.path.isfile(cache_file):
    f = open(cache_file,'w')
    f.write(status_now)
    f.close()
    sys.exit(0)
f = open(cache_file,'r')
status_last=f.read()
f.close()
f = open(cache_file,'w')
f.write(status_now)
f.close()
if not status_last:
    f = open(cache_file,'w')
    f.write(status_now)
    f.close()
    sys.exit(0)
status_last_list = status_last.split()
cpu_idle_last=int(status_last_list[4])
cpu_iowait_last=int(status_last_list[5])
#因为/proc/stat 单位时cpu时间分片，一般为100ms,所以计算时要处以10转化为秒，再除以统计间隔时间
iowait=(cpu_iowait_now-cpu_iowait_last)/once
cpu_idle=(cpu_idle_now-cpu_idle_last)/once
cpu_usage=100-cpu_idle
if sys.argv[1] == 'usage':
    print cpu_idle
elif sys.argv[1] == 'iowait':
    print iowait
else:
    print iowait
    print cpu_idle
    

