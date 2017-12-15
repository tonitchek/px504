#!/bin/bash

currdate=`LC_ALL=en_US.utf8 date`

echo $currdate

# Set PI date
ssh pi@192.168.1.11 "sudo date -s \"$currdate\""
ssh pi@192.168.1.12 "sudo date -s \"$currdate\""
#ssh pi@192.168.1.13 "sudo date -s \"$currdate\""

# Wait clock is OK... (paranoid)
sleep 2

# Startup Geth client on PI remotely & manually (yes, it's dirty! missing time...)
ssh pi@192.168.1.11
ssh pi@192.168.1.12
ssh pi@192.168.1.13
