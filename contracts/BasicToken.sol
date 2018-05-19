pragma solidity ^ 0.4 .23;

import "./SafeMath.sol";
import "./ERC20Basic.sol";
// ----------------------------------------------------------------------------
// Basic version of StandardToken, with no allowances.
// ----------------------------------------------------------------------------

contract BasicToken is ERC20Basic {
    using SafeMath for uint256; 
    address public reservedTokens; 
    address public advisorTokens;
    address public founderTokens;
    uint256 public afterIcoLockingPeriod;
    uint256 public reserveTokenLockPeriod;
    uint256 public founderTokenLockPeriod;
    mapping(address => uint256)balances;
     uint256 totalSupply_;
      modifier checkAfterICOLock() {

        if (msg.sender == owner) {
            _;
        }else if(msg.sender == reservedTokens){
              if(now<reserveTokenLockPeriod){
                revert();
            }else{
                _;
            }
        }else if(msg.sender == founderTokens){
              if(now<founderTokenLockPeriod){
                revert();
            }else{
                _;
            }
        }
         else {
            if(now<afterIcoLockingPeriod){
                revert();
            }else{
                _;
            }
        }

    }
  /**
  * update ico lock period time
  */
    function updateAfterIcoLockPeriod(uint256 _afterIcoLockingPeriod) public onlyOwner {
        afterIcoLockingPeriod = _afterIcoLockingPeriod;
    }
    /**
  * @dev total number of tokens in existence
  */
    function totalSupply()public view returns(uint256) {
        return totalSupply_;
    }

    /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
    function transfer(address _to, uint256 _value)public whenNotPaused checkAfterICOLock returns(
        bool
    ) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
    function balanceOf(address _owner)public view returns(uint256) {
        return balances[_owner];
    }

}