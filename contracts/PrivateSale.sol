pragma solidity ^0.4.24;

import "./ERC20Basic.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

/**
 * @title Toke Time Lock
 * @dev private sale tokens locked in this contract and released after fixed time.
 */
 contract PrivateSale is Ownable {

  using SafeMath for uint256;

  // ERC20 basic token contract being held Araw Token as reference
  ERC20Basic token;

  // Timestamp when token release is enabled
  uint256 public releaseTime;

  //Private sale bonus tokens will be locked
  mapping (address => uint256) public privateBonusLockedBalance;

  //Event when private token will be locked for address
  event PrivateTokenLock(address indexed _from, address indexed _to, uint256 tokens);

  //Event when private token will be unlocked
  event PrivateTokenUnlock(address indexed to, uint256 tokens);

  //Track no of tokens alocated to users and after private sale return remaining tokens back to owner
  uint256 privateBonusLockedTokens;
  /**
  * @param _token This hold the erc20 araw token address on network.
  */
  constructor (address _token)
  public
  {
    owner = msg.sender;  
    token = ERC20Basic(_token);  //araw erc20 token contract
    releaseTime = now + 120 days;
  } 

  /**
  * @dev Helps to transfer private sale tokens as to lock bonus tokens for 6 months
  * @param _to Address where balance to transfer
  * @param tokenTransfer These token will be released instantly
  * @param tokenLock These are bonus tokens which will be locked for 6 months
  */
  function doPrivateSale(address _to, uint256 tokenTransfer, uint256 tokenLock) 
  onlyOwner 
  public 
  {
    //require(_to != address(0)); //unnecessary because this require in function 'transfer' 
    require(tokenTransfer > 0);
    require(tokenLock > 0);
    
    token.transfer(_to, tokenTransfer);
    
    privateBonusLockedBalance[_to] = privateBonusLockedBalance[_to].add(tokenLock);
    privateBonusLockedTokens = privateBonusLockedTokens.add(tokenLock);
    
    emit PrivateTokenLock(msg.sender, _to, tokenLock);
  }


   /**
   * @dev This helps to release tokens of any private sale customers by owner
   * Now can be used without parameter 'to'
   * @param _to This helps to token transfer which is hold
   */
  function releasePrivateLockToken(address _to)
  public 
  {
    require(now > releaseTime);

    if (_to == address(0)){
      _to = msg.sender;
    }

    require(privateBonusLockedBalance[_to] > 0);

    token.transfer(_to,privateBonusLockedBalance[_to]);
    
    privateBonusLockedTokens = privateBonusLockedTokens.sub(privateBonusLockedBalance[_to]);
    emit PrivateTokenUnlock(_to, privateBonusLockedBalance[_to]);
 
    privateBonusLockedBalance[_to] = 0;
  } //end of release


  /**
  * @dev after private sale when tokens remain in this contract, 
  * it helps to transfer all remaining tokens back to owner
  */
  function depositRemainingTokensToOwner ()
  onlyOwner 
  public 
  {
    uint256 remainingTokensNotLocked = token.balanceOf(address(this)).sub(privateBonusLockedTokens);
    token.transfer(owner,remainingTokensNotLocked);
  }
  
}
