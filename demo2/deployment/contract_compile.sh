#!/bin/bash

OUTDIR=bet_contract_compiled

#compile contract
solcjs --optimize --bin --abi ../app/src/Bet.sol -o $OUTDIR
#get BIN
BIN=`cat $OUTDIR/*.bin`
#get ABI
ABI=`cat $OUTDIR/*.abi`
#write in JSON file
echo "CONTRACT='{\"bin\":\"0x$BIN\",\"abi\":$ABI}';" > bet_contract.json
#copy JSON to app for users package
cp bet_contract.json ../app/src/
