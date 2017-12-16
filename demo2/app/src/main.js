var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//read contract ABI
var betABI = JSON.parse(ABI);
//set contract address deployed on the blockchain in order to interact with it
var betAddress = '0x670e5f29f41d7e743f7b2ca2decf00f01d703626';
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
}, 1000);

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
