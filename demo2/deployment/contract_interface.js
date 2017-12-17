var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//parse contract JSON file
var contractJSON = JSON.parse(CONTRACT);
//variable storing the Bet contract bytecode
var betBytecode = contractJSON.bin;
//variable storing the Bet contract ABI
var betAbi = contractJSON.abi;
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
	var betContract = web3.eth.contract(betAbi).at(betAddress);
	var betAndValue = betContract.getBetsCountAndValue({from: userAddress, gas: 500000});
	document.getElementById("betLength").value = betAndValue[0];
	document.getElementById("totalBetValue").value = web3.fromWei(betAndValue[1],"ether");
    }
}, 1000);

function deploy() {
    if(betBytecode && betAbi) {
	//get instance
	var betContract = web3.eth.contract(betAbi);
	//create/deploy contract
	var bet = betContract.new({from: userAddress, data: betBytecode, gas: 900000},
				  function(e, contract) {
				      if(!e) {
					  if(!contract.address) {
				              alert("Tx Hash: "+contract.transactionHash);
					  } else {
					      alert("Contract mined! Address: " + contract.address);
					      betAddress = contract.address;
					      fs.writeFile("betContractAddr.txt",betAddress,'utf8');
					  }
				      } else {
					  alert(e);
				      }
				  });
    } else {
	alert("Contract source empty! Load a contract before deploying...");
    }
}

function updateAddr() {
    betAddress = document.getElementById("contractAddress").value;
}

function initFund() {
    //get contract instance
    if(betAbi && betAddress) {
	var betContract = web3.eth.contract(betAbi).at(betAddress);
	var amount = document.getElementById("initAmount").value;
	alert(amount);
	betContract.initBank({from: userAddress, value: web3.toWei(amount,"ether"), gas: 500000});
    }
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
