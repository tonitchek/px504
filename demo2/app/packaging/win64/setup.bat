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

:: start node
.\geth.exe --datadir %DATADIR% --identity %HOSTNAME% --mine --minerthreads=1 --maxpeers 100 --networkid 170788 --rpcapi "db,personal,admin,eth,net,web3,miner" --rpc --rpccorsdomain "*" --nat extip:192.168.1.* --bootnodes "enode://b81413b112e315ed8d6ec7c6ce22d7146b803521599f55f6da39803f4a0e9f05235c1632fc2be2093c215d7be343fe0d864a1cdb497ad1f7da5a9ab36f674a17@192.168.1.1:30303"
