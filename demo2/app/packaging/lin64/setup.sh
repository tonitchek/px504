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
# try with firefox
if ! [ -x firefox ]
then
    # firefox is not installed or not in the path
    # try with chrome
    if ! [ -x chrome ]
    then
        echo "---------"
        echo "Firefox nor Chrome found. App didn't start..."
	echo "Please open index.html in your favorite browser"
        echo "---------"
    else
        echo "---------"
        echo "App started in a new Chrome tab"
        echo "---------"
    fi
else
    # firefox exists and can be run
    firefox --new-tab app/index.html &> /dev/null &
    firefox --new-tab 192.168.1.1:8000 &> /dev/null &
    firefox --new-tab 192.168.1.1:3000 &> /dev/null &
    echo "---------"
    echo "App started in a new Firefox tab"
    echo "---------"
fi


# start node
./geth --datadir $DATADIR --identity $HOSTNAME --mine --minerthreads=1 --maxpeers 100 --networkid 170788 --rpcapi "db,personal,admin,eth,net,web3,miner" --rpc --rpccorsdomain "*"
