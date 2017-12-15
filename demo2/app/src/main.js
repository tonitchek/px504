var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//set contract ABI
var betABI = [ { "constant": false, "inputs": [], "name": "launch", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "bets", "outputs": [ { "name": "betType", "type": "uint8", "value": "0" }, { "name": "player", "type": "address", "value": "0x" }, { "name": "number", "type": "uint256", "value": "0" }, { "name": "value", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "kill", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "nextRoundTimestamp", "outputs": [ { "name": "", "type": "uint256", "value": "1513003423" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "number", "type": "uint256" } ], "name": "betSingle", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "lastRoundTimestamp", "outputs": [ { "name": "", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "_interval", "outputs": [ { "name": "", "type": "uint256", "value": "30" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "betEven", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "_creator", "outputs": [ { "name": "", "type": "address", "value": "0x7ebd6263509566e09a857a0846cc82ba0b81a09c" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getBetsCountAndValue", "outputs": [ { "name": "", "type": "uint256", "value": "0" }, { "name": "", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "betOdd", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [ { "name": "interval", "type": "uint256", "index": 0, "typeShort": "uint", "bits": "256", "displayName": "interval", "template": "elements_input_uint", "value": "30" } ], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "number", "type": "uint256" }, { "indexed": false, "name": "nextRoundTimestampold", "type": "uint256" } ], "name": "Finished", "type": "event" } ]
//set contract address deployed on the blockchain in order to interact with it
var betAddress = '0x91811EFb1700ba86539E53e4509898d7517653d4';
//set contract address in HTML output text
document.getElementById("contractAddress").value = betAddress;
//get contract instance
var betContract = web3.eth.contract(betABI).at(betAddress);

//get user account address
var userAddress = web3.eth.accounts[0];
//set user account address in HTML output text
document.getElementById("userAddress").value = userAddress;
//unlock user account to avoid asking password (for demo...)
web3.personal.unlockAccount(userAddress,"secret");

//function refreshing user & contract balances every second
setInterval(function() {
    //get user account balance
    var userBalance = web3.eth.getBalance(userAddress);
    document.getElementById("userBalance").value = web3.fromWei(userBalance,"ether");
    //get contract balance
    var betBalance = web3.eth.getBalance(betAddress);
    document.getElementById("contractBalance").value = web3.fromWei(betBalance,"ether");
}, 3000);

function submit() {
    //get user bet amount
    var amount = document.getElementById("miseAmount").value;
    if(document.getElementById("betSingle").checked == true) {
        //choice is single
	var userNumber = document.getElementById("userBetSingleNumber").value;
	betContract.betSingle(userNumber,{from: userAddress, value: web3.toWei(amount,"ether"), gas: 500000});
    }
    else if(document.getElementById("betOdd").checked == true) {
        //choice is odd
	betContract.betOdd({from: userAddress, value: web3.toWei(amount,"ether"), gas: 500000});
    }
    else {
        //choice is even
	betContract.betEven({from: userAddress, value: web3.toWei(amount,"ether"), gas: 500000});
    }
}

function send() {
    var recvAddr = document.getElementById("recvAddress").value;
    var amount = document.getElementById("txAmount").value;
    web3.eth.sendTransaction({from: userAddress, to: recvAddr, value: web3.toWei(amount,"ether"), gas: 500000});
}
