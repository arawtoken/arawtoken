pragma solidity ^ 0.4 .24;

import "./Pausable.sol";
// ----------------------------------------------------------------------------
// ERC20 Simpler Interface
// ----------------------------------------------------------------------------

contract ERC20Basic is Pausable 
{
    function totalSupply ()
    public 
    view 
    returns(uint256);

    function balanceOf (address who) 
    public 
    view 
    returns(uint256);
    
    function transfer (address to, uint256 value)
    public 
    returns(bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
}