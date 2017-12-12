var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
// NOTE in mist web3 is already available, so check first if it's available before instantiating
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
//with authentication
//var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545", 0, BasicAuthUsername, BasicAuthPassword));

var version = web3.version.api;
console.log(version); // "0.2.0"

var betContractABI = [ { "constant": false, "inputs": [], "name": "launch", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "", "type": "uint256" } ], "name": "bets", "outputs": [ { "name": "betType", "type": "uint8", "value": "0" }, { "name": "player", "type": "address", "value": "0x" }, { "name": "number", "type": "uint256", "value": "0" }, { "name": "value", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "kill", "outputs": [], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "nextRoundTimestamp", "outputs": [ { "name": "", "type": "uint256", "value": "1511510163" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "number", "type": "uint256" } ], "name": "betSingle", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "lastRoundTimestamp", "outputs": [ { "name": "", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "_interval", "outputs": [ { "name": "", "type": "uint256", "value": "5" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "betEven", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "constant": true, "inputs": [], "name": "_creator", "outputs": [ { "name": "", "type": "address", "value": "0xf02e4f5e33f06422c361bc1e09765a0190d1a034" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "getBetsCountAndValue", "outputs": [ { "name": "", "type": "uint256", "value": "0" }, { "name": "", "type": "uint256", "value": "0" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [], "name": "betOdd", "outputs": [], "payable": true, "stateMutability": "payable", "type": "function" }, { "inputs": [ { "name": "interval", "type": "uint256", "index": 0, "typeShort": "uint", "bits": "256", "displayName": "interval", "template": "elements_input_uint", "value": "5" } ], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "number", "type": "uint256" }, { "indexed": false, "name": "nextRoundTimestampold", "type": "uint256" } ], "name": "Finished", "type": "event" } ];
var betContractAddress = '0x91811EFb1700ba86539E53e4509898d7517653d4';
var betContract = web3.eth.contract(betContractABI).at(betContractAddress);

var account = web3.eth.accounts[0];
console.log(account);
web3.personal.unlockAccount(account,"secret");
document.getElementById("account").value = account;

var initBalance = web3.eth.getBalance(account);
document.getElementById("balance").value = web3.fromWei(initBalance,"ether");

function getBalance() {
    if(!web3.isConnected()) {
	// show some dialog to ask the user to start a node
	document.getElementById("balance").value = "Please start a node...";
	console.log("Please start a node...");
    } else {
	// start web3 filters, calls, etc
	var balance = web3.eth.getBalance("0xf02e4f5e33f06422c361bc1e09765a0190d1a034");
	document.getElementById("balance").value = web3.fromWei(balance,"ether");
	console.log(balance); // instanceof BigNumber
	console.log(balance.toString(10)); // '1000000000000'
	console.log(balance.toNumber()); // 1000000000000
	console.log(web3.fromWei(balance,"ether")); //to ETH
    }
}

function getBlock() {
    if(!web3.isConnected()) {
	// show some dialog to ask the user to start a node
	document.getElementById("blockNb").value = "Please start a node...";
	console.log("Please start a node...");
    } else {
	// start web3 filters, calls, etc
	var block = web3.eth.blockNumber;
	document.getElementById("blockNb").value = block;
	console.log(block); // instanceof BigNumber
    }
}

function submit() {
//    if( document.getElementById("betSingle").checked && document.getElementById("betDouble").checked ) {
//	alert("Only one choice is available...");
//    }
    var result = stoContract.get();
    document.getElementById("storedValue").value = result;
}

function store() {
//    if( document.getElementById("betSingle").checked && document.getElementById("betDouble").checked ) {
//	alert("Only one choice is available...");
    //    }
    var data = parseInt(document.getElementById('storeValue').value, 10);
    var result = stoContract.set(data);
}


//// UPDATE LABEL
//setInterval(function() {
//  // Account balance in Ether
//  var balanceWei = web3.eth.getBalance(("0xf02e4f5e33f06422c361bc1e09765a0190d1a034").toNumber();
//  var balance = web3.fromWei(balanceWei, 'ether');
//  document.getElementById("balance").value = balance;
//  // Block number
//  var number = web3.eth.blockNumber;
//  document.getElementById("blockNb").value = number;
//}, 1000);
