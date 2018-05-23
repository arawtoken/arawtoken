pragma solidity ^ 0.4 .18;

import "./StandardToken.sol";

contract ArawToken is StandardToken {
    string public symbol;
    string public name;
    uint256 public decimals;
    uint public _totalSupply;
    using SafeMath for uint256;
    uint256 public releaseTime1;
    uint256 public releaseTime2;
    uint256 public releaseTime3;
    bool public isReleaseTime1;
    bool public isReleaseTime2;
    bool public isReleaseTime3;
    enum State {
        Active,
        Closed
    }
    event Closed();
    State public state;
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor()public {
        symbol = "ARAW";
        name = "ARAW TOKEN";
        decimals = 18;
        owner = msg.sender;
        totalSupply_ = 5000000000 * (10 ** decimals);
        reservedTokens = 0x82ea2755a38637dD20322378266bf01260D35C73;
        founderTokens = 0xC47830DE1DEe63f8fCAa562bc5A78457A5DAe819;
        advisorTokens = 0x19EBB94B0df82400cfDAdFC4cbC77c3e1Bad1304;
        balances[msg.sender] = balances[msg.sender].add(3650000000 * (10 ** decimals));
        balances[reservedTokens] = balances[reservedTokens].add(
            750000000 * (10 ** decimals)
        );
        balances[founderTokens] = balances[founderTokens].add(
            450000000 * (10 ** decimals)
        );
       
        state = State.Active;
        emit Transfer(address(0), msg.sender, balances[msg.sender]);
        emit Transfer(address(0), reservedTokens, balances[reservedTokens]);
        emit Transfer(address(0), founderTokens, balances[founderTokens]);
    }

    function releaseAdvisorTokens() public {
         require(state == State.Closed);
        if(now < releaseTime1){
            revert();
        }else if(now>releaseTime1 && now <releaseTime2 && !isReleaseTime1){
            isReleaseTime1 = true;
            releaseTokenAdvisor(30);
            //here we will
        }else if (now>releaseTime2 &&now < releaseTime3&& !isReleaseTime2){
            if(!isReleaseTime1){
                 releaseTokenAdvisor(30);
            }
            isReleaseTime1 = true;
            isReleaseTime2 = true;
             releaseTokenAdvisor(30);
            
        }else if( now>releaseTime3 &&!isReleaseTime3){
               if(!isReleaseTime1){
                 releaseTokenAdvisor(30);
              }
              if(!isReleaseTime2){
                 releaseTokenAdvisor(30);
              }
              releaseTokenAdvisor(40);
             isReleaseTime1 = true;
             isReleaseTime2 = true;
             isReleaseTime3 = true;
        }else {
            revert();
        }
    }
    function releaseTokenAdvisor(uint256 percent) internal returns(bool){
        uint256 totalAdvisorCoins = 150000000 *  (10 ** decimals);
        uint256 releasedTokens =  (percent.mul(totalAdvisorCoins)).div(100);
         balances[advisorTokens] = balances[reservedTokens].add(
            releasedTokens
        );
        emit Transfer(address(0), advisorTokens, balances[advisorTokens]);
    }
    // ------------------------------------------------------------------------
    // Doesn't Accept Eth
    // ------------------------------------------------------------------------
    function ()public payable {
        revert();
    }
    function close() onlyOwner public {
        require(state == State.Active);
        state = State.Closed;
        afterIcoLockingPeriod = now + 12 weeks;
        founderTokenLockPeriod = now + 365 days;
        reserveTokenLockPeriod = now + 1095 days; //3 years
        releaseTime1 = now + 12 weeks; //3 months to unlock 30 %
        releaseTime2 = now + 24 weeks; // 6 months to unlock 30%
        releaseTime3 = now + 365 days; //1 year to unlock 40 %
        emit Closed();
    }

}
