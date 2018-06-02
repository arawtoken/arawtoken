pragma solidity ^0.4.24;

import "./ERC20.sol";

contract AirDrop  {
    /**
     * @param _tokenAddr transfer token from owner address
     * @param recipients array of ERC20 ETH addresses
     * @param values array of total tokens to be transferred to each address (one-to-one mapping)
     */
    function multisend(address _tokenAddr, address[] recipients, uint256[] values) 
    public 
    returns(uint256) 
    {
        require(recipients.length == values.length);
        
        uint256 i = 0;
        while (i < recipients.length) 
        {
            ERC20(_tokenAddr).transfer(recipients[i], values[i]);
            i += 1;
        }
        return (i);
    }
}