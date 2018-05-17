pragma solidity ^ 0.4 .18;

import "./StandardToken.sol";

contract ArawToken is StandardToken {
    string public symbol;
    string public name;
    uint256 public decimals;
    uint public _totalSupply;
    using SafeMath for uint256; enum State {
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
        balances[founderTokens] = balances[reservedTokens].add(
            150000000 * (10 ** decimals)
        );
        balances[advisorTokens] = balances[reservedTokens].add(
            150000000 * (10 ** decimals)
        );
        state = State.Active;
        emit Transfer(address(0), msg.sender, balances[msg.sender]);
        emit Transfer(address(0), reservedTokens, balances[reservedTokens]);
        emit Transfer(address(0), founderTokens, balances[founderTokens]);
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
        emit Closed();
    }

}
