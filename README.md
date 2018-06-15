# ARAW 

ARAW is the Decentralised Payment for E-Commerce Ecosystem.
We are on a mission to provide end-to-end solutions for E-Commerce Marketplace, Touch & Pay Cryptocurrency Card, Online Cryptocurrency Payment, and Unified Reward System powered by the Ethereum Blockchain.

Check https://arawtoken.io/ for more details.

Please note that this repository is under development. The code here will be under continual audit and improved until release of the completed system.

# ARAW Smart Contracts

* `contracts/` contains smart contract code to be deployed.
* `contracts/AirDrop.sol`  helps to airdrop tokens.
* `contracts/ArawToken.sol`  defining token information and assigning tokens to pool.
* `contracts/BasicToken.sol` ERC20 Basic Function implementation.
* `contracts/ERC20.sol` ERC20 interface.
* `contracts/ERC20Basic.sol` Basic ERC20 function interface.
* `contracts/Ownable.sol` a contract with an owner.
* `contracts/SafeMath.sol` a library to handle all basic math operations like sum, divide or multiply, with built-in safety checking.
* `contracts/StandardToken.sol` a contract contain implementation of ERC20 interface and contain burn functionality. This contract also helps to handle token lock functionality.
* `contracts/BurnableToken.sol` a contract with burnable functionality.
* `contracts/StandardBurnableToken.sol` a contract which contains logic from Standard Token contract and Burnable. 
* `tests/` test cases.

# SetUp & Run Unit Tests

## Setup 
```
Step#1: Install npm
https://www.npmjs.com/get-npm
npm install npm@latest -g

Step#2: Install truffle:
http://truffleframework.com/
npm install -g truffle

Step#3: Install testRpc
https://github.com/trufflesuite/ganache-cli
npm install -g ganache-cli

Step#4: Install external package chai:
https://www.npmjs.com/package/chai
npm install chai

Step#5: Install external package chai-as-promised:
https://www.npmjs.com/package/chai-as-promised
npm install chai-as-promised
```
## Run

```
Step#1: Navigate to root folder
Step#2: Run 'testrpc' or 'ganache-cli' from console
Step#3: Open another console and from root folder run 'truffle test'
```

## Result

```
$ truffle test
Compiling ./contracts/AirDrop.sol...
Compiling ./contracts/ArawToken.sol...
Compiling ./contracts/BasicToken.sol...
Compiling ./contracts/BurnableToken.sol...
Compiling ./contracts/ERC20.sol...
Compiling ./contracts/ERC20Basic.sol...
Compiling ./contracts/Migrations.sol...
Compiling ./contracts/Ownable.sol...
Compiling ./contracts/PrivateSale.sol...
Compiling ./contracts/SafeMath.sol...
Compiling ./contracts/StandardBurnableToken.sol...
Compiling ./contracts/StandardToken.sol...


  Contract: Check Token contract
    Check SC instance
      ✓ catch an instance of tokenContract
      ✓ Saving totalSupply
    Check initial parameters
      ✓ Check Token name
      ✓ Check Token Symbol
      ✓ check Token Decimals
    Get tokenHolders addresses
      ✓ check owner address
      ✓ check reservedTokensAddress address
      ✓ check foundersTokensAddress address
      ✓ check advisorsTokensAddress address
    Check initial balances
      ✓ check owner balance (112ms)
      ✓ check reservedTokensAddress balance
      ✓ check foundersTokensAddress balance
      ✓ check holded for advisorsTokensAddress in contract balance
    Check function transfer
      ✓ check owner possibility to transfer tokens (231ms)
      ✓ check another user possibility to transfer tokens (218ms)
    close ICO
      ✓ owner try to close ICO (125ms)
      ✓ owner try to close ICO again (this transacion must failed)
    Check PrivateSale contract
      ✓ catch an instance of private sale contract
      ✓ send some owners tokens to privateSaleContract
      ✓ check doPrivateSale function (134ms)
      ✓ check his balance now (97ms)
      ✓ check his locked tokens (100ms)
      ✓ check releasePrivateLockToken function (90ms)
    increase EVM time
1529078978
      ✓ get blockTimestamp now (175ms)
      ✓ increse up to 121 days (182ms)
1539533379
      ✓ get blockTimestamp again (174ms)
    release advisors tokens
      ✓ calling releaseadvisorsTokens function (40ms)
      ✓ check advisorsBalance now
      ✓ try to call again (transacion must failed)
      ✓ increse time to 3d release (184ms)
      ✓ call releaseadvisorsTokens (42ms)
      ✓ check advisorsBalance now
      ✓ try to call again (transacion must failed)
      ✓ call releasePrivateLockToken now (137ms)
      ✓ check his balance now (98ms)
      ✓ check his locked tokens now (99ms)
      ✓ check owner balance (99ms)
      ✓ check contract balance
      ✓ call depositRemainingTokensToOwner (39ms)
      ✓ check owners balance now (100ms)


  40 passing (3s)

```


