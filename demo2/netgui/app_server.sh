#!/bin/bash

appserver_pid_file="appserver.pid"
CURDIR=`pwd`

function help() {
    echo -e "USAGE:"
    echo -e "    $0 command"
    echo -e "COMMANDS:"
    echo -e "    start\tstart DAPP server"
    echo -e "    status\treturn \"Running\" if DAPP server is running or \"Stopped\" otherwise"
    echo -e "    stop\tstop DAPP server"
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

function appserver() {
    if [ -f $appserver_pid_file ]
    then
	echo "DAPP server already started!!!"
    else
	http-server ./www -c-1 -p 8888 &> /dev/null &
        sleep 2
        firefox --new-tab http://localhost:8888 &> /dev/null &
        APPSERVER_PID=`ps -ef |grep "./www -p 8888" | awk 'NR==1 {print $2}'`
	if [ -z $APPSERVER_PID ]
	then
	    echo "DAPP server failed to start..."
	    exit 1
	else
	    echo $APPSERVER_PID > $appserver_pid_file
            echo -e "DAPP server done."
	fi
    fi
}

function stop() {
    if [ -e $appserver_pid_file ]
    then
	APPSERVER_PID=`cat $appserver_pid_file`
        kill $APPSERVER_PID
	rm -rf $appserver_pid_file
        echo "Stop done."
    else
	echo "DAPP server is not running..."
	exit 0
    fi
}

#default local file
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
	    appserver
	    ;;
	status)
	    if [ -e $appserver_pid_file ]
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
