pragma solidity ^ 0.4 .24;

import "./StandardToken.sol";

contract ArawToken is StandardToken {
    string public symbol;
    string public name;
    uint256 public decimals;

    uint public _totalSupply;

    using SafeMath for uint256;

    /* Variables to manage Advisors tokens vesting periods time */
    uint256 public advisorsTokensFirstReleaseTime; 
    uint256 public advisorsTokensSecondReleaseTime; 
    uint256 public advisorsTokensThirdReleaseTime; 
    
    /* Flags to indicate Advisors tokens released */
    bool public isAdvisorsTokensFirstReleased; 
    bool public isAdvisorsTokensSecondReleased; 
    bool public isAdvisorsTokensThirdReleased; 

    /* Total advisors tokens allocated */
    uint256 totalAdvisorsLockedTokens; 

    /* The outstnading advisors tokens balance */
    uint256 public advisorsLockedTokensBalance; 
    
    /* ICO status */
    enum State {
        Active,
        Closed
    }

    mapping(address => uint256)public privateBonusLockedTokens;

    event PrivateTokenLock(
        address indexed _from,
        address indexed _to,
        uint256 tokens
    );

    uint256 public privLockTokenTime;

    event Closed();

    State public state;
    
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() 
    public 
    {
        symbol = "ARAW";
        name = "ARAW TOKEN";
        decimals = 18;
        owner = msg.sender;
        totalSupply_ = 5000000000 * (10 ** decimals);
        
        reservedTokensAddress = 0x82ea2755a38637dD20322378266bf01260D35C73;
        foundersTokensAddress = 0xC47830DE1DEe63f8fCAa562bc5A78457A5DAe819;
        advisorsTokensAddress = 0x19EBB94B0df82400cfDAdFC4cbC77c3e1Bad1304;
       
        balances[msg.sender] = balances[msg.sender].add(3650000000 * (10 ** decimals));
        balances[reservedTokensAddress] = balances[reservedTokensAddress].add(
            750000000 * (10 ** decimals)
        );
        balances[foundersTokensAddress] = balances[foundersTokensAddress].add(
            450000000 * (10 ** decimals)
        );
        
        totalAdvisorsLockedTokens = 150000000 * (10 ** decimals);
        advisorsLockedTokensBalance = totalAdvisorsLockedTokens;
       
        state = State.Active;
       
        emit Transfer(address(0), msg.sender, balances[msg.sender]);
        emit Transfer(address(0), reservedTokensAddress, balances[reservedTokensAddress]);
        emit Transfer(address(0), foundersTokensAddress, balances[foundersTokensAddress]);
        privLockTokenTime = now + 182 days;
    }

    /**
    * release tokens for advisors
    **/
    function releaseadvisorsTokensAddress()
    public 
    {
        require(state == State.Closed);
        
        if (now < advisorsTokensFirstReleaseTime)
        {
            revert();
        } else if (now > advisorsTokensFirstReleaseTime 
        && now < advisorsTokensSecondReleaseTime 
        && !isAdvisorsTokensFirstReleased) 
        {
            isAdvisorsTokensFirstReleased = true;
            releaseTokenAdvisor(30);
        } else if (now > advisorsTokensSecondReleaseTime 
        && now < advisorsTokensThirdReleaseTime 
        && !isAdvisorsTokensSecondReleased) 
        {
            if (!isAdvisorsTokensFirstReleased) {
                releaseTokenAdvisor(30);
            }
            
            isAdvisorsTokensFirstReleased = true;
            isAdvisorsTokensSecondReleased = true;
            
            releaseTokenAdvisor(30);

        } else if (now > advisorsTokensThirdReleaseTime 
        && !isAdvisorsTokensThirdReleased) 
        {
            if (!isAdvisorsTokensFirstReleased)
            {
                releaseTokenAdvisor(30);
            }
           
            if (!isAdvisorsTokensSecondReleased) 
            {
                releaseTokenAdvisor(30);
            }
           
            releaseTokenAdvisor(40);
           
            isAdvisorsTokensFirstReleased = true;
            isAdvisorsTokensSecondReleased = true;
            isAdvisorsTokensThirdReleased = true;
        } else
        {
            revert();
        }
    }

    /**
    * @param percent tokens release for advisors from their pool
    **/
    function releaseTokenAdvisor(uint256 percent) 
    internal 
    returns(bool) 
    {
        uint256 releasedTokens = (percent.mul(totalAdvisorsLockedTokens)).div(100);
        require(advisorsLockedTokensBalance >= releasedTokens);
        balances[advisorsTokensAddress] = balances[advisorsTokensAddress].add(releasedTokens);
        advisorsLockedTokensBalance = advisorsLockedTokensBalance.sub(releasedTokens);
        emit Transfer(advisorsTokensAddress, advisorsTokensAddress, balances[advisorsTokensAddress]);
    }

    // ------------------------------------------------------------------------
    // Doesn't Accept Eth
    // ------------------------------------------------------------------------
    function ()
    public 
    payable 
    {
        revert();
    }

    /**
    * After ICO close it helps to lock tokens for pools
    **/
    function close()
    onlyOwner 
    public 
    {
        require(state == State.Active);
        state = State.Closed;
        
        foundersTokensLockedPeriod = now + 365 days;
        reservedTokensAddressLockedPeriod = now + 1095 days; //3 years
        advisorsTokensFirstReleaseTime = now + 12 weeks; //3 months to unlock 30 %
        advisorsTokensSecondReleaseTime = now + 24 weeks; // 6 months to unlock 30%
        advisorsTokensThirdReleaseTime = now + 365 days; //1 year to unlock 40 %
        
        emit Closed();
    }

    /**
    *helps to transfer private sale tokens as to lock bonus tokens for 6 months
    * params _to address where balance to transfer
    * params tokenTransfer these token will be released instantly
    * params tokenLock these are bonus tokens which will be locked for 6 months
    */
    function privateSale(address _to, uint256 tokenTransfer, uint256 tokenLock)
    onlyOwner 
    public 
    {
        require(_to != address(0));
        require(tokenTransfer > 0);
        require(tokenLock > 0);
        
        transfer(_to, tokenTransfer);
        
        require(balances[msg.sender] >= tokenLock);
        
        balances[msg.sender] = balances[msg.sender].sub(tokenLock);
        privateBonusLockedTokens[_to] = privateBonusLockedTokens[_to].add(tokenLock);
       
        emit PrivateTokenLock(msg.sender, _to, tokenLock);
    }

    /*
    * this helps to release tokens of any private sale customers by owner
    * params _to this helps to token transfer which is hold
    */
    function releasePrivateLockToken(address _to)
    onlyOwner 
    public 
    {
        require(now > privLockTokenTime);
        uint256 tokensToUnlock = privateBonusLockedTokens[_to];
        require(tokensToUnlock > 0);
       
        privateBonusLockedTokens[_to] = privateBonusLockedTokens[_to].sub(tokensToUnlock);
        balances[_to] = balances[_to].add(tokensToUnlock);
       
        emit Transfer(_to, _to, tokensToUnlock);
    } //end of release

}