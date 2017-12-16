#!/bin/bash

DATADIR=$PWD/etherpn

# user unzipped package. Create datadir
mkdir -p $PWD/$DATADIR

# initialize blockchain
./geth --datadir $DATADIR init genesis.json
echo "---------"
echo "Private Ethereum blockchain initialized"
echo "---------"

# create account
./geth --datadir $DATADIR --password $PWD/password account new
echo "---------"
echo "Account created"
echo "---------"


# open index.html user interface
open app/index.html
open 192.168.1.1:8888
open 192.168.1.1:8000
open 192.168.1.1:3000

# start node
./geth --datadir $DATADIR --identity $HOSTNAME --mine --minerthreads=1 --maxpeers 100 --networkid 170788 --rpcapi "db,personal,admin,eth,net,web3,miner" --rpc --rpccorsdomain "*"
