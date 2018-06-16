pragma solidity ^0.4.24;

import "./StandardBurnableToken.sol";
import "./Ownable.sol";

contract ArawToken is StandardBurnableToken, Ownable {

  using SafeMath for uint256;

  string public symbol = "ARAW";
  string public name = "ARAW";
  uint256 public decimals = 18;

  /* Wallet address will be changed for production */ 
  address public arawWallet;

  /* Locked tokens addresses - will be changed for production */
  address public reservedTokensAddress;
  address public foundersTokensAddress;
  address public advisorsTokensAddress;

  /* Variables to manage Advisors tokens vesting periods time */
  uint256 public advisorsTokensFirstReleaseTime; 
  uint256 public advisorsTokensSecondReleaseTime; 
  uint256 public advisorsTokensThirdReleaseTime; 
  
  /* Flags to indicate Advisors tokens released */
  bool public isAdvisorsTokensFirstReleased; 
  bool public isAdvisorsTokensSecondReleased; 
  bool public isAdvisorsTokensThirdReleased; 

  /* Variables to hold reserved and founders tokens locking period */
  uint256 public reservedTokensLockedPeriod;
  uint256 public foundersTokensLockedPeriod;

  /* Total advisors tokens allocated */
  uint256 totalAdvisorsLockedTokens; 

  modifier checkAfterICOLock () {
    if (msg.sender == reservedTokensAddress){
        require (now >= reservedTokensLockedPeriod);
    }
    if (msg.sender == foundersTokensAddress){
        require (now >= foundersTokensLockedPeriod);
    }
    _;
  }

  function transfer(address _to, uint256 _value) 
  public 
  checkAfterICOLock 
  returns (bool) {
    super.transfer(_to,_value);
  }

  function transferFrom(address _from, address _to, uint256 _value) 
  public 
  checkAfterICOLock 
  returns (bool) {
    super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) 
  public 
  checkAfterICOLock 
  returns (bool) {
    super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) 
  public 
  checkAfterICOLock 
  returns (bool) {
    super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) 
  public 
  checkAfterICOLock 
  returns (bool) {
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

  event Closed();

  State public state;

  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------
  constructor(address _reservedTokensAddress, address _foundersTokensAddress, address _advisorsTokensAddress, address _arawWallet) public {
    owner = msg.sender;

    reservedTokensAddress = _reservedTokensAddress;
    foundersTokensAddress = _foundersTokensAddress;
    advisorsTokensAddress = _advisorsTokensAddress;

    arawWallet = _arawWallet;

    totalSupply_ = 5000000000 ether;
   
    balances[msg.sender] = 3650000000 ether;
    balances[reservedTokensAddress] = 750000000 ether;
    balances[foundersTokensAddress] = 450000000 ether;
    
    totalAdvisorsLockedTokens = 150000000 ether;
    balances[this] = 150000000 ether;
   
    state = State.Active;
   
    emit Transfer(address(0), msg.sender, balances[msg.sender]);
    emit Transfer(address(0), reservedTokensAddress, balances[reservedTokensAddress]);
    emit Transfer(address(0), foundersTokensAddress, balances[foundersTokensAddress]);
    emit Transfer(address(0), address(this), balances[this]);
  }

  /**
   * @dev release tokens for advisors
   */
  function releaseAdvisorsTokens() public returns (bool) {
    require(state == State.Closed);
    
    require (now > advisorsTokensFirstReleaseTime);
    
    if (now < advisorsTokensSecondReleaseTime) {   
      require (!isAdvisorsTokensFirstReleased);
      
      isAdvisorsTokensFirstReleased = true;
      releaseAdvisorsTokensForPercentage(30);

      return true;
    }

    if (now < advisorsTokensThirdReleaseTime) {
      require (!isAdvisorsTokensSecondReleased);
      
      if (!isAdvisorsTokensFirstReleased) {
        isAdvisorsTokensFirstReleased = true;
        releaseAdvisorsTokensForPercentage(60);
      } else{
        releaseAdvisorsTokensForPercentage(30);
      }
      
      isAdvisorsTokensSecondReleased = true;
      return true;
    }

    require (!isAdvisorsTokensThirdReleased);

    if (!isAdvisorsTokensFirstReleased) {
      releaseAdvisorsTokensForPercentage(100);
    } else if (!isAdvisorsTokensSecondReleased) {
      releaseTokenAdvisor(70);
    } else{
      releaseAdvisorsTokensForPercentage(40);
    }

    isAdvisorsTokensFirstReleased = true;
    isAdvisorsTokensSecondReleased = true;
    isAdvisorsTokensThirdReleased = true;

    return true;
  } 
  
  /**
   * @param percent tokens release for advisors from their pool
   */
  function releaseAdvisorsTokensForPercentage(uint256 percent) internal {
    uint256 releasedTokens = (percent.mul(totalAdvisorsLockedTokens)).div(100);

    balances[advisorsTokensAddress] = balances[advisorsTokensAddress].add(releasedTokens);
    balances[this] = balances[this].sub(releasedTokens);
    emit Transfer(this, advisorsTokensAddress, releasedTokens);
  }

  /**
   * @dev all ether transfer to another wallet automatic
   */
  function () public payable {
    require(state == State.Active); // Reject the transactions after ICO ended

    arawWallet.transfer(msg.value);
  }

  /**
  * After ICO close it helps to lock tokens for pools
  **/
  function close() onlyOwner public {
    require(state == State.Active);
    state = State.Closed;
    
    foundersTokensLockedPeriod = now + 365 days;
    reservedTokensLockedPeriod = now + 1095 days; //3 years
    advisorsTokensFirstReleaseTime = now + 12 weeks; //3 months to unlock 30 %
    advisorsTokensSecondReleaseTime = now + 24 weeks; // 6 months to unlock 30%
    advisorsTokensThirdReleaseTime = now + 365 days; //1 year to unlock 40 %
    
    emit Closed();
  }
}