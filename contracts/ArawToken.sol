pragma solidity ^0.4.24;

import "./StandardBurnableToken.sol";
import "./Ownable.sol";

contract ArawToken is StandardBurnableToken, Ownable {

  using SafeMath for uint256;

  string public symbol = "ARAW";
  string public name = "ARAW";
  uint256 public decimals = 18;

  /* Variables to manage Advisors tokens vesting periods time */
  uint256 public advisorsTokensFirstReleaseTime; 
  uint256 public advisorsTokensSecondReleaseTime; 
  uint256 public advisorsTokensThirdReleaseTime; 
  
  /* Flags to indicate Advisors tokens released */
  bool public isAdvisorsTokensFirstReleased; 
  bool public isAdvisorsTokensSecondReleased; 
  bool public isAdvisorsTokensThirdReleased; 

  address public reservedTokensAddress; 
  address public advisorsTokensAddress;
  address public foundersTokensAddress;

  uint256 public reservedTokensAddressLockedPeriod;
  uint256 public foundersTokensLockedPeriod;

  /* Total advisors tokens allocated */
  uint256 totalAdvisorsLockedTokens; 

  /* The outstnading advisors tokens balance */
  uint256 public advisorsLockedTokensBalance; 

  modifier checkAfterICOLock () {
    if (msg.sender == reservedTokensAddress){
        require (now >= reservedTokensAddressLockedPeriod);
    }
    if (msg.sender == foundersTokensAddress){
        require (now >= foundersTokensLockedPeriod);
    }
    _;
  }

  function transfer(address _to, uint256 _value) public checkAfterICOLock returns (bool) {
    super.transfer(_to,_value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public checkAfterICOLock returns (bool){
    super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public checkAfterICOLock returns (bool) {
    super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public checkAfterICOLock returns (bool) {
    super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public checkAfterICOLock returns (bool) {
    super.decreaseApproval(_spender, _subtractedValue);
  }
  /**
   * @dev Transfer ownership now transfers all owners tokens to new owner 
   */
  function transferOwnership(address newOwner) public onlyOwner {
    balances[newOwner] = balances[newOwner].add(balances[owner]);
    emit Transfer(owner, newOwner, balances[owner]);
    balances[owner] = 0;

    super.transferOwnership(newOwner);
  }

  /* ICO status */
  enum State {
    Active,
    Closed
  }

  mapping (address => uint256) public privateBonusLockedTokens;
  mapping (address => uint256) public publicBonusLockedTokens;

  event PrivateTokenLock(address indexed _from, address indexed _to, uint256 tokens);

  uint256 public privLockTokenTime;

  event Closed();

  State public state;

  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------
  constructor() public {
    owner = msg.sender;
    totalSupply_ = 5000000000 ether;
    
    reservedTokensAddress = 0x82ea2755a38637dD20322378266bf01260D35C73;
    foundersTokensAddress = 0xC47830DE1DEe63f8fCAa562bc5A78457A5DAe819;
    advisorsTokensAddress = 0x19EBB94B0df82400cfDAdFC4cbC77c3e1Bad1304;
   
    balances[msg.sender] = 3650000000 ether;
    balances[reservedTokensAddress] = 750000000 ether;
    balances[foundersTokensAddress] = 450000000 ether;
    
    totalAdvisorsLockedTokens = 150000000 ether;
    balances[this] = 150000000 ether;
    advisorsLockedTokensBalance = totalAdvisorsLockedTokens;
   
    state = State.Active;
   
    emit Transfer(address(0), msg.sender, balances[msg.sender]);
    emit Transfer(address(0), reservedTokensAddress, balances[reservedTokensAddress]);
    emit Transfer(address(0), foundersTokensAddress, balances[foundersTokensAddress]);
    emit Transfer(address(0), address(this), balances[this]);

    privLockTokenTime = now + 182 days;
  }

  /**
   * @dev release tokens for advisors
   */
  function releaseadvisorsTokensAddress() public returns (bool) {
    require(state == State.Closed);
    
    require (now > advisorsTokensFirstReleaseTime);
    if (now < advisorsTokensSecondReleaseTime) {   
      require (!isAdvisorsTokensFirstReleased);
      
      isAdvisorsTokensFirstReleased = true;
      releaseTokenAdvisor(30);

      return true;
    }
    if (now < advisorsTokensThirdReleaseTime) {
      require (!isAdvisorsTokensSecondReleased);
      
      if (!isAdvisorsTokensFirstReleased) {
        isAdvisorsTokensFirstReleased = true;
        releaseTokenAdvisor(60);
      } else{
        releaseTokenAdvisor(30);
      }
      
      isAdvisorsTokensSecondReleased = true;
      return true;
    }

    require (!isAdvisorsTokensThirdReleased);
    if (!isAdvisorsTokensFirstReleased) {
      releaseTokenAdvisor(100);
    } else if (!isAdvisorsTokensSecondReleased) {
      releaseTokenAdvisor(70);
    } else{
      releaseTokenAdvisor(40);
    }

    isAdvisorsTokensFirstReleased = true;
    isAdvisorsTokensSecondReleased = true;
    isAdvisorsTokensThirdReleased = true;

    return true;
  } 
  
  /**
   * @param percent tokens release for advisors from their pool
   */
  function releaseTokenAdvisor(uint256 percent) internal {
    uint256 releasedTokens = (percent.mul(totalAdvisorsLockedTokens)).div(100);

    balances[advisorsTokensAddress] = balances[advisorsTokensAddress].add(releasedTokens);
    balances[this] = balances[this].sub(releasedTokens);
    emit Transfer(this, advisorsTokensAddress, releasedTokens);
  }

  /**
   * @dev all ether transfer to another wallet automatic
   */
  function () public payable {
    0x441455B4eA7cF900DDA364700F7872897B7A93cc.transfer(msg.value);
  }

  /**
  * After ICO close it helps to lock tokens for pools
  **/
  function close() onlyOwner public {
    require(state == State.Active);
    state = State.Closed;
    
    foundersTokensLockedPeriod = now + 365 days;
    reservedTokensAddressLockedPeriod = now + 1095 days; //3 years
    advisorsTokensFirstReleaseTime = now + 12 weeks; //3 months to unlock 30 %
    advisorsTokensSecondReleaseTime = now + 24 weeks; // 6 months to unlock 30%
    advisorsTokensThirdReleaseTime = now + 365 days; //1 year to unlock 40 %

    //Private sell BONUS tokens will be locked for 3 months after the ICO ended.
    privLockTokenTime = now + 120 days;
    
    emit Closed();
  }

  /**
   *helps to transfer private sale tokens as to lock bonus tokens for 6 months
   * param _to Address where balance to transfer
   * param tokenTransfer These token will be released instantly
   * param tokenLock These are bonus tokens which will be locked for 6 months
   */
  function privateSale(address _to, uint256 tokenTransfer, uint256 tokenLock) onlyOwner public 
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

  /**
   * @dev This helps to release tokens of any private sale customers by owner
   * Now can be used without parameter 'to'
   * param _to This helps to token transfer which is hold
   */
  function releasePrivateLockToken(address _to) public 
  {
    require(now > privLockTokenTime);

    if (_to == address(0)){
      _to = msg.sender;
    }

    require(privateBonusLockedTokens[_to] > 0);
    balances[_to] = balances[_to].add(privateBonusLockedTokens[_to]);
  
    emit Transfer(msg.sender, _to, privateBonusLockedTokens[_to]);
    
    privateBonusLockedTokens[_to] = 0;
  } //end of release
}