var Web3 = require('web3');
// create an instance of web3 using the HTTP provider.
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

//parse contract JSON file
var contractJSON = JSON.parse(CONTRACT);
//variable storing the Bet contract ABI
var betAbi = contractJSON.abi;
//set contract address deployed on the blockchain in order to interact with it
var betAddress;

//variable stroring if user already played
var hasPlayed = false;
//variable storing results list
var resultsList="";

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
    //get contract address from HTML input text
    betAddress = document.getElementById("contractAddress").value;
    //get contract balance
    var betBalance = web3.eth.getBalance(betAddress);
    document.getElementById("contractBalance").value = web3.fromWei(betBalance,"ether");
}, 1000);

function submit() {
    if(hasPlayed == false) {
        if(betAddress) {
            var betContract = web3.eth.contract(betAbi).at(betAddress);
            //get user bet amount
            var amount = document.getElementById("miseAmount").value;
	    if(amount > 10) {
		alert("Montant maximum autorisé pour parier: 10ETH");
	    } else {
		
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
                //start watching event for winners
                var event = betContract.Winner(function(error, result) {
                    if (!error) {
	        	    resultsList += "player address:"+result.args.player+", profit:"+web3.fromWei(result.args.value,"ether")+", bet number:"+result.args.number.toNumber()+"\n";
	        	    document.getElementById("results").value=resultsList;
                	}
                });
                alert("Merci d'avoir jouer! Attendez le lancement de la roulette");
	        hasPlayed = true;
	    }
        }
    }
}

function send() {
    var recvAddr = document.getElementById("recvAddress").value;
    var amount = document.getElementById("txAmount").value;
    web3.eth.sendTransaction({from: userAddress, to: recvAddr, value: web3.toWei(amount,"ether"), gas: 500000});
}
