var Token = artifacts.require("ArawToken.sol")
var PrivateSale = artifacts.require("PrivateSale.sol")

var TokenName = "ARAW";
var Symbol = "ARAW";
var TokenSupply = 5000000000;
var Decimals = 18;

var TokenBuffer = 0;

expect = require("chai").expect;

var totalSupply;

var owner;
var reservedTokensAddress;
var foundersTokensAddress;
var advisorsTokensAddress;
var arawWallet;

contract("Check Token contract", function(accounts){

  describe("Check SC instance", function(){
    it("catch an instance of tokenContract", function(){
      return Token.deployed().then(function(instance){
        TokenInstance = instance;
      });
    });
    it("Saving totalSupply", function(){
      return TokenInstance.totalSupply().then(function(res){
        totalSupply = res.toString();
        expect(res.toString()).to.be.equal((TokenSupply*(Math.pow(10,Decimals))).toString());
      });
    });
  });

  describe ("Check initial parameters", function () {
    it ("Check Token name", function(){
      return TokenInstance.name.call().then(function(res){
        expect(res.toString()).to.be.equal(TokenName);
      })
    })
    it ("Check Token Symbol", function(){
      return TokenInstance.symbol.call().then(function(res){
        expect(res.toString()).to.be.equal(Symbol);
      })
    })
    it ("check Token Decimals", function(){
      return TokenInstance.decimals.call().then(function(res){
        expect(parseInt(res.toString())).to.be.equal(Decimals);
      })
    })
  })

  describe ("Get tokenHolders addresses", function() {
    it ("check owner address", function(){
      return TokenInstance.owner.call().then(function(res){
        owner = res.toString();
      })
    })

    it ("check reservedTokensAddress address", function(){
      return TokenInstance.reservedTokensAddress.call().then(function(res){
        reservedTokensAddress = res.toString();
      })
    })

    it ("check foundersTokensAddress address", function(){
      return TokenInstance.foundersTokensAddress.call().then(function(res){
        foundersTokensAddress = res.toString();
      })
    })

    it ("check advisorsTokensAddress address", function(){
      return TokenInstance.advisorsTokensAddress.call().then(function(res){
        advisorsTokensAddress = res.toString();
      })
    })
    it ("check arawWallet address", function(){
      return TokenInstance.arawWallet.call().then(function(res){
        arawWallet = res.toString();
      })
    })
  })

  describe ("Check initial balances", function(){
    it ("check owner balance", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[0]).then(function(res){
        expect(res.toString()).to.be.equal((3650000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check reservedTokensAddress balance", function(){
      return TokenInstance.balanceOf(reservedTokensAddress).then(function(res){
        expect(res.toString()).to.be.equal((750000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check foundersTokensAddress balance", function(){
      return TokenInstance.balanceOf(foundersTokensAddress).then(function(res){
        expect(res.toString()).to.be.equal((450000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check holded for advisorsTokensAddress in contract balance", function(){
      return TokenInstance.balanceOf(TokenInstance.address).then(function(res){
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)).toString());
      });
    });
  });

  describe ("Check function transfer", function (){
    it ("check owner possibility to transfer tokens", function(){
      return TokenInstance.transfer(web3.eth.accounts[2], 100, {from: web3.eth.accounts[0]}).then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
    it ("check another user possibility to transfer tokens", function(){
      return TokenInstance.transfer(web3.eth.accounts[3], 100, {from: web3.eth.accounts[2]}).then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
  })

  var bufferBalance;

  describe ("Check buying function", function(){
    it ("check arawWallet balance", function(){
      bufferBalance = web3.eth.getBalance(arawWallet).toString();
    })

    it ("send 0.05 ETH to contract", async function(){
      try {
        await web3.eth.sendTransaction({from: web3.eth.accounts[6], to: TokenInstance.address, value: 50000000000000000})
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
    it ("send 0.1 ETH to contract", async function(){
      try {
        await web3.eth.sendTransaction({from: web3.eth.accounts[6], to: TokenInstance.address, value: 100000000000000000})
        assert.ok(true, "It should not fail");
      } catch(error){
        assert.ok(false, "It mustn't failed")
      }
    })
    it ("check arawWallet balance now", function(){
      expect(web3.eth.getBalance(arawWallet).toString()/1).to.be.equal(bufferBalance/1 + 100000000000000000);
    })
  })

  describe ("close ICO", function(){
    it ("owner try to close ICO", function(){
      return TokenInstance.close({from: web3.eth.accounts[0]}).then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
    it ("owner try to close ICO again (this transacion must failed)", async function(){
      try {
        await TokenInstance.TokenInstance.close({from: web3.eth.accounts[0]})
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
  })

  describe ("Check buying function now", function(){
    it ("check arawWallet balance", function(){
      bufferBalance = web3.eth.getBalance(arawWallet).toString();
    })

    it ("send 0.05 ETH to contract", async function(){
      try {
        await web3.eth.sendTransaction({from: web3.eth.accounts[6], to: TokenInstance.address, value: 50000000000000000})
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
    it ("send 0.1 ETH to contract", async function(){
      try {
        await web3.eth.sendTransaction({from: web3.eth.accounts[6], to: TokenInstance.address, value: 50000000000000000})
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
    it ("check arawWallet balance now", function(){
      expect(web3.eth.getBalance(arawWallet).toString()).to.be.equal(bufferBalance);
    })
  })

  describe("Check PrivateSale contract", function(){
    it("catch an instance of private sale contract", function(){
      return PrivateSale.deployed().then(function(instance){
        PrivateSaleInstance = instance;
      });
    });
    it("send some owners tokens to privateSaleContract", async function(){
        try {
        await TokenInstance.transfer(PrivateSaleInstance.address, 3000000000*Math.pow(10,Decimals));
        assert.ok(true, "It should not fail");
      } catch(error){
        assert.ok(false, "It mustn't failed")
      }
    });

    it("check doPrivateSale function", async function(){
      try {
        await PrivateSaleInstance.doPrivateSale(web3.eth.accounts[5], 1000, 300);
        assert.ok(true, "It should not fail");
      } catch(error){
        assert.ok(false, "It mustn't failed")
      }
    })

    it("check his balance now", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[5]).then(function(res){
        expect(res.toString()).to.be.equal('1000');
      })
    })
    it("check his locked tokens", function(){
      return PrivateSaleInstance.privateBonusLockedBalance(web3.eth.accounts[5]).then(function(res){
        expect(res.toString()).to.be.equal('300')
      })
    })

    it("check releasePrivateLockToken function", async function(){
      try {
        await PrivateSaleInstance.releasePrivateLockToken({from: web3.eth.accounts[5]});
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
  });

  describe ("increase EVM time", function(){
    it ("get blockTimestamp now", function(){
      console.log("current timestamp = " + web3.eth.getBlock(web3.eth.blockNumber).timestamp);
    })


    it("increse up to 121 days", function(){  
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [10454400], id: 0})
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
    })

    it ("get blockTimestamp again", function(){
      console.log("current timestamp = " + web3.eth.getBlock(web3.eth.blockNumber).timestamp);
    })
  })

  describe("release advisors tokens", function(){
    it ("calling releaseAdvisorsTokens function", function(){
      return TokenInstance.releaseAdvisorsTokens().then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })

    it ("check advisorsBalance now", function(){
      return TokenInstance.balanceOf(advisorsTokensAddress).then(function(res){
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)/100*30).toString())
      })
    })

    it ("try to call again (transacion must failed)", async function(){
      try {
        await TokenInstance.releaseAdvisorsTokens()
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })

    it ("increse time to 3d release", function(){
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [21600000], id: 0})
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
    })

    it ("call releaseAdvisorsTokens", function(){
      return TokenInstance.releaseAdvisorsTokens().then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
    it ("check advisorsBalance now", function(){
      return TokenInstance.balanceOf(advisorsTokensAddress).then(function(res){
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)).toString())
      })
    })

    it ("try to call again (transacion must failed)", async function(){
      try {
        await TokenInstance.releaseAdvisorsTokens()
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })

    it ("call releasePrivateLockToken now", async function(){
      try {
        await PrivateSaleInstance.releasePrivateLockToken(web3.eth.accounts[5]);
        assert.ok(true, "It should not fail");
      } catch(error){
        assert.ok(false, "It mustn't failed")
      }
    })

    it ("check his balance now", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[5]).then(function(res){
        expect(res.toString()).to.be.equal('1300');
      })
    })
    it("check his locked tokens now", function(){
      return PrivateSaleInstance.privateBonusLockedBalance(web3.eth.accounts[5]).then(function(res){
        expect(res.toString()).to.be.equal('0')
      })
    })
    it("check owner balance", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[0]).then(function(res){
        owner_balance = res.toString();
      })
    })
    it("check contract balance", function(){
      return TokenInstance.balanceOf(PrivateSaleInstance.address).then(function(res){
        contract_balance = res.toString();
      })
    })

    it("call depositRemainingTokensToOwner", async function(){
      try{
        await PrivateSaleInstance.depositRemainingTokensToOwner()
        assert.ok(true, "it shouldn't fail")
      }
      catch(error){
        assert.ok(false, "it must not failed")
      }
    })
    it("check owners balance now", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[0]).then(function(res){
        expect(res.toString()/1).to.be.equal(owner_balance/1 + contract_balance/1);
      })
    })
  })
})