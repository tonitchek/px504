REM Srcipt starting a node on a private Ethereum network
@ECHO OFF

SET DATADIR=%cd%/etherpn

:: user unzipped package. Create datadir
mkdir -p %cd%/%DATADIR%

:: initialize blockchain
.\geth.exe --datadir %DATADIR% init genesis.json
echo "---------"
echo "Private Ethereum blockchain initialized"
echo "---------"

:: create account
.\geth.exe --datadir %DATADIR% --password %cd%/password account new
echo "---------"
echo "Account created"
echo "---------"


:: open index.html user interface
start app/index.html
start 192.168.1.1:8000
start 192.168.1.1:3000

:: start node
.\geth.exe --datadir %DATADIR% --identity %HOSTNAME% --mine --minerthreads=1 --maxpeers 100 --networkid 170788 --rpcapi "db,personal,admin,eth,net,web3,miner" --rpc --rpccorsdomain "*"
