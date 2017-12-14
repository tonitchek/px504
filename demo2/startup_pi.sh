#!/bin/bash

currdate=`LC_ALL=en_US.utf8 date`

echo $currdate

# Set PI date
ssh pi@192.168.1.11 "sudo date -s \"$currdate\""
ssh pi@192.168.1.12 "sudo date -s \"$currdate\""
ssh pi@192.168.1.13 "sudo date -s \"$currdate\""

# Wait clock is OK... (paranoid)
#sleep 2

# Startup Geth client on PI
#generic geth command
#geth --datadir /home/pi/data/ --identity $HOSTNAME --maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner --rpc --rpccorsdomain "*" --nat extip:192.168.1.$IP --bootnodes "enode://b81413b112e315ed8d6ec7c6ce22d7146b803521599f55f6da39803f4a0e9f05235c1632fc2be2093c215d7be343fe0d864a1cdb497ad1f7da5a9ab36f674a17@192.168.1.1:30303" --nodekey /home/pi/data/bootkey_$HOSTNAME.key

#ssh pi@192.168.1.11 "geth --datadir /home/pi/data/ --identity $HOSTNAME " \
#    "--maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner " \
#    "--rpc --rpccorsdomain "*" --nat extip:192.168.1.11 --nodekey " \
#    "/home/pi/data/bootkey_$HOSTNAME.key --bootnodes \"enode://b81413b112e315ed8d6ec7c6ce22d7146b803521599f55f6da39803f4a0e9f05235c1632fc2be2093c215d7be343fe0d864a1cdb497ad1f7da5a9ab36f674a17@192.168.1.1:30303\""
#
#ssh pi@192.168.1.12 "geth --datadir /home/pi/data/ --identity $HOSTNAME " \
#    "--maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner " \
#    "--rpc --rpccorsdomain "*" --nat extip:192.168.1.12 --nodekey " \
#    "/home/pi/data/bootkey_$HOSTNAME.key --bootnodes \"enode://b81413b112e315ed8d6ec7c6ce22d7146b803521599f55f6da39803f4a0e9f05235c1632fc2be2093c215d7be343fe0d864a1cdb497ad1f7da5a9ab36f674a17@192.168.1.1:30303\""
#
#ssh pi@192.168.1.13 "geth --datadir /home/pi/data/ --identity $HOSTNAME " \
#    "--maxpeers 100 --networkid 170788 --rpcapi personal,admin,eth,net,web3,miner " \
#    "--rpc --rpccorsdomain "*" --nat extip:192.168.1.13 --nodekey " \
#    "/home/pi/data/bootkey_$HOSTNAME.key --bootnodes \"enode://b81413b112e315ed8d6ec7c6ce22d7146b803521599f55f6da39803f4a0e9f05235c1632fc2be2093c215d7be343fe0d864a1cdb497ad1f7da5a9ab36f674a17@192.168.1.1:30303\""
