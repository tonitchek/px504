#!/bin/bash

geth --datadir $PWD/data init genesis.json
sleep 1
geth --datadir $PWD/data --password $PWD/password account new
sleep 1
bootnode --genkey $PWD/data/bootkey_$HOSTNAME.key
