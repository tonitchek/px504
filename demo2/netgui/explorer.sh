#!/bin/bash

explorer_pid_file="explorer.pid"
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

function explorer() {
    if [ -f $explorer_pid_file ]
    then
	echo "Explorer already started!!!"
    else
        cd ../../demo1/explorer
        npm start &> /dev/null &
        sleep 4
        firefox --new-tab http://localhost:8000 &> /dev/null &
        EXPLORER_PID=`ps -ef |grep "localhost -p 8000" | awk 'NR==2 {print $2}'`
	if [ -z $EXPLORER_PID ]
	then
	    echo "Explorer failed to start..."
	    exit 1
	else
	    echo $EXPLORER_PID > $CURDIR/$explorer_pid_file
            cd $CURDIR
            echo -e "Explorer done."
	fi
    fi
}

function stop() {
    if [ -e $explorer_pid_file ]
    then
	EXPLORER_PID=`cat $explorer_pid_file`
        kill $EXPLORER_PID
	rm -rf $explorer_pid_file
        echo "Stop done."
    else
	echo "Explorer is not running..."
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
	    explorer
	    ;;
	status)
	    if [ -e $explorer_pid_file ]
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
