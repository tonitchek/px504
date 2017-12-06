#!/bin/bash

nodes_pid_file="nodes.pid"
explorer_pid_file="explorer.pid"
monitor_pid_file="monitor.pid"
monitor_appjson_file="app.json"
bootnodes_file="static-nodes.json"

function help() {
    echo -e "USAGE:"
    echo -e "    $0 [options] command"
    echo -e "OPTIONS:"
    echo -e "    --log\tstore logs output of all nodes in a file for each node"
    echo -e "    --help\tprint this help"
    echo -e "COMMANDS:"
    echo -e "    init\tinitialize a private network. A local \"nodes.conf\" " \
	 "file must be present."
    echo -e "This file must contain a list of nodes and their configuration."
    echo -e "File syntax:"
    echo -e "\t<node name identity>,<RPC port>,<listening port>,<miner flag>"
    echo -e "\twhere miner flag is 1 if node must mining, 0 (or anything else) "\
	 "node must not mining"
    echo -e "    start\tstart all nodes of the private blockchain. A local "\
	 "nodes.conf file must be present."
    echo -e "This file must contain a list of nodes and their configuration."
    echo -e "File syntax:"
    echo -e "\t<node name identity>,<RPC port>,<listening port>,<miner flag>"
    echo -e "\twhere miner flag is 1 if node must mining, 0 (or anything else) "\
	 "node must not mining"
    echo -e "    status\treturn a \"Running\" if private blockchain is running or \"Stopped\" otherwise"
    echo -e "    stop\tstop the private blockchain. All nodes will be stoped, monitor and explorer tools will be stopped too"
    echo -e "    monitor\tlaunch a localhost server monitoring all nodes of the private blockchain"
    echo -e "    explorer\tlaunch a localhost server allowing to explore all blocks of the private blockchain"
}


###### START
if [ $# -eq 0 ]
then
    help
    exit 1
fi

function init() {
    if [ -f $bootnodes_file ]
    then
	rm -rf $bootnodes_file
    fi
    node_nb=`wc -l $1 | awk '{print $1}'`
    echo -e "[" > $bootnodes_file
    while read NODE
    do
	node_name=`awk -F"," '{print $1}' <<< $NODE`
        port=`awk -F"," '{print $3}' <<< $NODE`
        if [ ! -d $PWD/$node_name ]
        then
    	  echo "Node doesn't exist. Initializing..."
    	  mkdir $PWD/$node_name
    	  geth --datadir $PWD/$node_name init genesis.json
    	  echo $node_name > password
    	  geth --datadir $PWD/$node_name --password $PWD/password account new
    	  rm password
        else
    	  echo "Node exists. Discard initialization..."
        fi
	cd $node_name
	bootnode --genkey bootkey_$node_name.key
	addr=`bootnode --nodekey bootkey_$node_name.key -writeaddress`
	cd ..
	(( var++ ))
	if [ $var -eq $node_nb ]
	then
	    echo -e "  \"enode://$addr@[::]:$port\"" >> $bootnodes_file
	else
	    echo -e "  \"enode://$addr@[::]:$port\"," >> $bootnodes_file
	fi
    done < $1
    echo -e "]" >> $bootnodes_file
    while read NODE
    do
	node_name=`awk -F"," '{print $1}' <<< $NODE`
	cd $node_name
	ln -sf ../$bootnodes_file
	cd ..
    done < $1
    echo "Initialization done."
}

function start() {
    if [ -f $nodes_pid_file ]
    then
	echo "Private blockchain already started!!!"
    else
        while read NODE
        do
	    node_name=`awk -F"," '{print $1}' <<< $NODE`
            rpcport=`awk -F"," '{print $2}' <<< $NODE`
            port=`awk -F"," '{print $3}' <<< $NODE`
            miner=`awk -F"," '{print $4}' <<< $NODE`
            if [ $2 -eq 1 ]
            then
		#log requested. Print output to log file
                geth --datadir $PWD/$node_name --identity $node_name --mine --minerthreads=1 --nodiscover --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --rpcport $rpcport --port $port --nodekey $PWD/$node_name/bootkey_$node_name.key > $node_name.log 2>&1 &
                if [ "$miner" != "1" ]
                then
		    #node must not mining. Stop mining
		    #wait node has been launched
		    sleep 1
		    curl -X POST --data '{"jsonrpc":"2.0","method":"miner_stop","params":[],"id":67}' localhost:$rpcport
                fi
            else
		#log not requestd. Redirect output to /dev/null
                geth --datadir $PWD/$node_name --identity $node_name --mine --minerthreads=1 --nodiscover --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --rpcport $rpcport --port $port --nodekey $PWD/$node_name/bootkey_$node_name.key > /dev/null 2>&1 &
		if [ "$miner" != "1" ]
                then
		    #node must not mining. Stop mining
		    #wait node has been launched
		    sleep 1
		    curl -X POST --data '{"jsonrpc":"2.0","method":"miner_stop","params":[],"id":67}' localhost:$rpcport
                fi
            fi
        done < $1
        jobs -rp > $nodes_pid_file
        echo "Start done."
    fi
}

function monitor() {
    if [ -f $monitor_pid_file ]
    then
	echo "Private blockchain monitor already started!!!"
    else
        cd monitor
	## create app.json
	rm -rf $monitor_appjson_file
	echo "[" > $monitor_appjson_file
        while read NODE
        do
        	node_name=`awk -F"," '{print $1}' <<< $NODE`
        	rpcport=`awk -F"," '{print $2}' <<< $NODE`
		echo -e "  {" >> $monitor_appjson_file
    		echo -e "    \"name\"            : \"$node_name\"," >> $monitor_appjson_file
    		echo -e "    \"cwd\"             : \".\"," >> $monitor_appjson_file
    		echo -e "    \"script\"          : \"app.js\"," >> $monitor_appjson_file
    		echo -e "    \"log_date_format\" : \"YYYY-MM-DD HH:mm Z\"," >> $monitor_appjson_file
    		echo -e "    \"merge_logs\"      : false," >> $monitor_appjson_file
    		echo -e "    \"watch\"           : false," >> $monitor_appjson_file
    		echo -e "    \"exec_interpreter\": \"node\"," >> $monitor_appjson_file
    		echo -e "    \"exec_mode\"       : \"fork_mode\"," >> $monitor_appjson_file
    		echo -e "    \"env\":" >> $monitor_appjson_file
    		echo -e "    {" >> $monitor_appjson_file
    		echo -e "      \"NODE_ENV\"      : \"test\"," >> $monitor_appjson_file
    		echo -e "      \"RPC_HOST\"      : \"localhost\"," >> $monitor_appjson_file
    		echo -e "      \"RPC_PORT\"      : \"$rpcport\"," >> $monitor_appjson_file
    		echo -e "      \"INSTANCE_NAME\" : \"$node_name\"," >> $monitor_appjson_file
    		echo -e "      \"WS_SERVER\"     : \"http://localhost:3000\"," >> $monitor_appjson_file
    		echo -e "      \"WS_SECRET\"     : \"secret\"," >> $monitor_appjson_file
    		echo -e "    }" >> $monitor_appjson_file
    		echo -e "  }," >> $monitor_appjson_file
        done < $1
	echo "]" >> $monitor_appjson_file
	cd eth-net-intelligence-api
	pm2 start ../app.json
	cd ../eth-netstats
	WS_SECRET=secret npm start &> /dev/null &
        sleep 2
        firefox --new-tab http://localhost:3000 &> /dev/null &
        pidof node > ../../$monitor_pid_file
        cd ../..
        echo -e "Monitor done."
    fi
}

function explorer() {
    if [ -f $explorer_pid_file ]
    then
	echo "Private blockchain explorer already started!!!"
    else
        cd explorer
        npm start &> /dev/null &
        sleep 4
        firefox --new-tab http://localhost:8000 &> /dev/null &
        pidof node > ../$explorer_pid_file
        cd ..
        echo -e "Explorer done."
    fi
}

function stop() {
    if [ -f $nodes_pid_file ]
    then
        while read NODE_PID
        do
        	kill $NODE_PID
        done < $nodes_pid_file
        rm -rf $nodes_pid_file
    fi
    if [ -f $explorer_pid_file ]
    then
	pid=`cat $explorer_pid_file`
	kill $pid
	rm -rf $explorer_pid_file
    fi
    if [ -f $monitor_pid_file ]
    then
	cd monitor
	pm2 delete app.json
	cd ..
	pid=`cat $monitor_pid_file`
	kill $pid
	rm -rf $monitor_pid_file
    fi
    echo "Stop done."
}

#default local file
node_conf=nodes.conf
do_init=0
do_start=0
do_log=0
do_stop=0
do_monitor=0
do_explorer=0

for cmd in "$@"
do
    case $cmd in
	--log)
	    do_log=1
	    ;;
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
        init)
	    do_init=1
	    ;;
        start)
	    do_start=1
	    ;;
	status)
	    state=`pidof geth`
	    if [ -z "$state" ]
	    then
		echo "Stopped"
	    else
		echo "Running"
	    fi
	    ;;
	stop)
	    do_stop=1
	    ;;
	monitor)
	    do_monitor=1
	    ;;
	explorer)
	    do_explorer=1
	    ;;
	*)
	    echo "$cmd: Bad argument"
	    help
	    exit 1
            ;;
    esac
done

if [ $do_init -eq 1 ]
then
    if [ ! -f $node_conf ]
    then
	echo "You must create a nodes.conf file containing nodes configuration."
	help
	exit 1
    fi
    init $PWD/$node_conf
fi

if [ $do_start -eq 1 ]
then
    if [ ! -f $node_conf ]
    then
	echo "You must create a nodes.conf file containing nodes configuration."
	help
	exit 1
    fi
    start $PWD/$node_conf $do_log
fi

if [ $do_monitor -eq 1 ]
then
    if [ ! -f $node_conf ]
    then
	echo "You must create a nodes.conf file containing nodes configuration."
	help
	exit 1
    fi
    monitor $PWD/$node_conf
fi

if [ $do_explorer -eq 1 ]
then
    explorer
fi

if [ $do_stop -eq 1 ]
then
    stop
fi

exit 0
