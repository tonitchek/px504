#!/bin/bash

DATADIR=$PWD/etherpn

# user unzipped package. Create datadir
mkdir $DATADIR
mv ./static-nodes.json $DATADIR

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
# try with firefox
firefox --new-tab app/index.html &> /dev/null &
firefox --new-tab 192.168.1.1:3000 &> /dev/null &
echo "---------"
echo "App started in a new Firefox tab"
echo "---------"

# start node
./geth --datadir $DATADIR --identity $HOSTNAME --mine --minerthreads=1 --maxpeers 100 --networkid 170788 --rpcapi "db,personal,admin,eth,net,web3,miner" --rpc --rpccorsdomain "*"
