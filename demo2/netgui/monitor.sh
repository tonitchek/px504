#!/bin/bash

monitor_pid_file="monitor.pid"
CURDIR=`pwd`

function help() {
    echo -e "USAGE:"
    echo -e "    $0 command"
    echo -e "COMMANDS:"
    echo -e "    start\tstart explorer"
    echo -e "    status\treturn \"Running\" if explorer is running or \"Stopped\" otherwise"
    echo -e "    stop\tstop explorer"
}

###### START
if [ $# -eq 0 ]
then
    help
    exit 1
fi
if [ $# -gt 1 ]
then
    help
    exit 1
fi

function monitor() {
    if [ -f $monitor_pid_file ]
    then
	echo "Monitor already started!!!"
    else
	cd ../../demo1/monitor/eth-net-intelligence-api
	pm2 start $CURDIR/app.json
	cd ../eth-netstats
	WS_SECRET=secret npm start &> /dev/null &
        sleep 2
        firefox --new-tab http://localhost:3000 &> /dev/null &
        MONITOR_PID=`ps -ef |grep "node ./bin/www" | awk 'NR==2 {print $2}'`
	if [ -z $MONITOR_PID ]
	then
	    echo "Monitor failed to start..."
	    exit 1
	else
	    echo $MONITOR_PID > $CURDIR/$monitor_pid_file
            cd $CURDIR
            echo -e "Monitor done."
	fi
	echo $MONITOR_PID > $CURDIR/$monitor_pid_file
        cd $CURDIR
        echo -e "Monitor done."
    fi
}

function stop() {
    if [ -e $monitor_pid_file ]
    then
	cd ../../demo1/monitor/
	pm2 delete $CURDIR/app.json
	cd $CURDIR
	pid=`cat $monitor_pid_file`
	kill $pid
	rm -rf $monitor_pid_file
        echo "Stop done."
    else
	echo "Monitor is not running..."
	exit 0
    fi
}

do_start=0
do_stop=0

for cmd in "$@"
do
    case $cmd in
	--help)
	    help
	    ;;
	-h)
	    help
	    ;;
	--*)
	    echo "$cmd: Bad option"
	    help
	    exit 1
	    ;;
        start)
	    monitor
	    ;;
	status)
	    if [ -e $monitor_pid_file ]
	    then
		echo "Running"
	    else
		echo "Stopped"
	    fi
	    ;;
	stop)
	    stop
	    ;;
	*)
	    echo "$cmd: Bad argument"
	    help
	    exit 1
            ;;
    esac
done
