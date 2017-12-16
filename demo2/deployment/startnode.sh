#!/bin/bash
#Description: Script starting the node. Input arg: 1=mining, otherwise no mining


function help() {
    echo "Usage: $0 <mining>"
    echo "mining:"
    echo "1 -> start the node mining"
    echo "otherwise -> start the node no mining"
    echo "Example: $0 1"
}

if [ $# -ne 1 ]
then
    help
    exit 1
fi

if [ "$1" == "1" ]
then
    geth --datadir $PWD/data/ --identity $HOSTNAME --mine --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --nat any --nodekey $PWD/data/bootkey_$HOSTNAME.key console
else
    geth --datadir $PWD/data/ --identity $HOSTNAME --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --nat any --nodekey $PWD/data/bootkey_$HOSTNAME.key console
fi
