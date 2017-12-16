var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//variable storing the Bet contract bytecode and ABI
var betBytecode;
//read contract ABI
var betAbi = JSON.parse(ABI);
//variable storing Bet contract address
var betAddress;

//get user account address
var userAddress = web3.eth.accounts[0];
//unlock user account to avoid asking password (for demo...)
web3.personal.unlockAccount(userAddress,"secret");

//function refreshing contract balance every second
setInterval(function() {
    //get contract balance
    if(betAddress) {
	var betBalance = web3.eth.getBalance(betAddress);
	document.getElementById("contractBalance").value = web3.fromWei(betBalance,"ether");
	document.getElementById("contractAddress").value = betAddress;
    }
}, 1000);

document.getElementById('contractBytecodeInput').addEventListener('change', readContractBytecode, false);
function readContractBytecode(evt) {
    //Retrieve the first (and only!) File from the FileList object
    var f = evt.target.files[0];
    if (f) {
	var r = new FileReader();
	r.onload = function(e) {
	    betBytecode = '0x'+e.target.result;
	}
	r.readAsText(f);
    } else {
	alert("!!!Failed to load contract source!!!");
    }
}

function deploy() {
    if(betBytecode && betAbi) {
	//get instance
	var betContract = web3.eth.contract(betAbi);
	//set constructor
	var _betInterval = 30;
	//defore deploying, estimate gas
	var estimatedGas = web3.eth.estimateGas({data: betBytecode});
	//create/deploy contract
	var bet = betContract.new(_betInterval,{from: userAddress, data: betBytecode, gas: 900000},
				  function(e, contract) {
				      if(!e) {
					  if(!contract.address) {
				              alert("Tx Hash: "+contract.transactionHash);
					  } else {
					      alert("Contract mined! Address: " + contract.address);
					      betAddress = contract.address;
					      fs.writeFile("betContractAddr.txt",betAddress,'utf8');
					  }
				      }
				  });
    } else {
	alert("Contract source empty! Load a contract before deploying...");
    }
}

function updateAddr() {
    betAddress = document.getElementById("contractAddress").value;
}

function launch() {
    //get contract instance
    if(betAbi && betAddress) {
	var betContract = web3.eth.contract(betAbi).at(betAddress);
	betContract.launch({from: userAddress, gas: 500000});
    }
}

function kill() {
    //get contract instance
    if(betAbi && betAddress) {
	var betContract = web3.eth.contract(betAbi).at(betAddress);
	betContract.kill({from: userAddress, gas: 500000});
    }
}
