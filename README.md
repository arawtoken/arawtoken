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
Step#2: 
  On Linux: run 'testrpc' from console
  On Mac: ganache-cli
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
Compiling ./contracts/SafeMath.sol...
Compiling ./contracts/StandardBurnableToken.sol...
Compiling ./contracts/StandardToken.sol...


  Contract: Token contract
    Check SC instance
tokenContract = 0x2a4257f030854ad23eb650f29f973cd89dcc1ad1
      ✓ catch an instance of tokenContract
totalSupply = 5e+27
      ✓ Saving totalSupply
    Check initial parameters
Token name = ARAW
      ✓ Check Token name
Token Symbol = ARAW
      ✓ Check Token Symbol
Token decimals = 18
      ✓ check Token Decimals
    Get tokenHolders addresses
owner = 0x48df9cd57bb0b4efcc644d865dfd1820c2917a9b
      ✓ check owner address
reservedTokensAddress = 0x82ea2755a38637dd20322378266bf01260d35c73
      ✓ check reservedTokensAddress address
foundersTokensAddress = 0xc47830de1dee63f8fcaa562bc5a78457a5dae819
      ✓ check foundersTokensAddress address
advisorsTokensAddress = 0x19ebb94b0df82400cfdadfc4cbc77c3e1bad1304
      ✓ check advisorsTokensAddress address
    Check initial balances
3.65e+27
      ✓ check owner balance (107ms)
7.5e+26
      ✓ check reservedTokensAddress balance
4.5e+26
      ✓ check foundersTokensAddress balance
1.5e+26
      ✓ check holded for advisorsTokensAddress in contract balance
    Check privateSale stage
      ✓ owner send 1000 tokens to another address, and lock 800 tokens (131ms)
      ✓ check his token balance (101ms)
      ✓ check his lockes tokens (103ms)
      ✓ try to release locked tokens (this transacion must failed) (105ms)
    Check function transfer
      ✓ check owner possibility to transfer tokens (210ms)
      ✓ check another user possibility to transfer tokens (210ms)
    close ICO
      ✓ owner try to close ICO (130ms)
      ✓ owner try to close ICO again (this transacion must failed)
    increase EVM time
1560614945
      ✓ get blockTimestamp now (183ms)
      ✓ increse up to 121 days (182ms)
1571069345
      ✓ get blockTimestamp again (174ms)
      ✓ release privateLockTokens now (177ms)
1.8e+21
      ✓ check his balance now (101ms)
    release advisors tokens
      ✓ calling releaseadvisorsTokensAddress function
4.5e+25
4.5e+25
      ✓ check advisorsBalance now
      ✓ try to call again (transacion must failed)
      ✓ increse time to 3d release (179ms)
      ✓ call releaseadvisorsTokensAddress (44ms)
1.5e+26
1.5e+26
      ✓ check advisorsBalance now
      ✓ try to call again (transacion must failed)


  33 passing (2s)
```


