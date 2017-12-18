pragma solidity ^0.4.11;

contract Roulette {

    address public _creator;

    enum BetType { Single, Odd, Even }

    struct Bet {
        BetType betType;
        address player;
        uint number;
        uint value;
    }

    Bet[] public bets;
    uint initialFund;

    event Winner (
        address player,
	uint value,
	uint number
    );
	
    function getBetsCountAndValue() public constant returns(uint, uint) {
        uint value = 0;
        for (uint i = 0; i < bets.length; i++) {
            value += bets[i].value;
        }
        return (bets.length, value);
    }

    modifier transactionMustContainEther() {
        require(msg.value > 0);
        _;
    }

    modifier bankMustBeAbleToPayForBetType(BetType betType) {
        uint necessaryBalance = 0;
        for (uint i = 0; i < bets.length; i++) {
            necessaryBalance += getPayoutForType(bets[i].betType) * bets[i].value;
        }
        necessaryBalance += getPayoutForType(betType) * msg.value;
        require(necessaryBalance <= this.balance);
        _;
    }

    modifier playerMustBeNew() {
        bool alreadyPlayed=false;
        for (uint i = 0; i < bets.length; i++) {
            if(msg.sender == bets[i].player) {
	        alreadyPlayed=true;
	    }
        }
	require(alreadyPlayed==false);
        _;
    }

    function getPayoutForType(BetType betType) private constant returns(uint) {
        if (betType == BetType.Single) return 10;
        if (betType == BetType.Even || betType == BetType.Odd) return 2;
        return 0;
    }

    function Roulette() public {
        _creator = msg.sender;
    }

    function initBank() public payable transactionMustContainEther() {
        initialFund = msg.value;
    }
    
    function betSingle(uint number) public payable transactionMustContainEther() bankMustBeAbleToPayForBetType(BetType.Single) playerMustBeNew() {
        require(number < 37);
        bets.push(Bet({
            betType: BetType.Single,
            player: msg.sender,
            number: number,
            value: msg.value
        }));
    }

    function betEven() public payable transactionMustContainEther() bankMustBeAbleToPayForBetType(BetType.Even) playerMustBeNew() {
        bets.push(Bet({
            betType: BetType.Even,
            player: msg.sender,
            number: 0,
            value: msg.value
        }));
    }

    function betOdd() public payable transactionMustContainEther() bankMustBeAbleToPayForBetType(BetType.Odd) playerMustBeNew() {
        bets.push(Bet({
            betType: BetType.Odd,
            player: msg.sender,
            number: 0,
            value: msg.value
        }));
    }

    function launch() public {
        require(msg.sender == _creator);

        uint number = uint(block.blockhash(block.number - 1)) % 37;

        for (uint i = 0; i < bets.length; i++) {
            bool won = false;

            if (bets[i].betType == BetType.Single) {
                if (bets[i].number == number) {
                    won = true;
                }
            } else if (bets[i].betType == BetType.Even) {
                if (number > 0 && number % 2 == 0) {
                    won = true;
                }
            } else if (bets[i].betType == BetType.Odd) {
                if (number > 0 && number % 2 == 1) {
                    won = true;
                }
            }
            if (won) {
                bets[i].player.transfer(bets[i].value * getPayoutForType(bets[i].betType));
		Winner(bets[i].player,bets[i].value * getPayoutForType(bets[i].betType),number);
            } else {
	        Winner(bets[i].player,0,number);
	    }
        }

        bets.length = 0;
    }

    function kill() public {
        require(msg.sender == _creator);
        selfdestruct(_creator);
    }
}
