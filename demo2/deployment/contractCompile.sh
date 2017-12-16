#!/bin/bash

OUTDIR=bet_contract_compiled

#compile contract
solcjs --optimize --bin --abi ../app/src/Bet.sol -o $OUTDIR
#get ABI
ABI=`cat $OUTDIR/*.abi`
echo "ABI='$ABI';" > bet_contract.json
#copy ABI to app for users package
cp bet_contract.json ../app/src/
