#!/bin/bash
#Description: Script starting the node

geth --datadir $PWD/data/ --identity $HOSTNAME --mine --minerthreads 1 --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --nat extip:192.168.1.1 --nodekey $PWD/data/bootkey_$HOSTNAME.key console
