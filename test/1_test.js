var Token = artifacts.require("ArawToken");

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

contract("Token contract", function(accounts){

  describe("Check SC instance", function(){
    it("catch an instance of tokenContract", function(){
      return Token.deployed().then(function(instance){
        TokenInstance = instance;
        console.log("tokenContract = " + TokenInstance.address);
      });
    });
    it("Saving totalSupply", function(){
      return TokenInstance.totalSupply().then(function(res){
        console.log("totalSupply = " + res.toString());
        totalSupply = res.toString();
        expect(res.toString()).to.be.equal((TokenSupply*(Math.pow(10,Decimals))).toString());
      });
    });
  });

  describe ("Check initial parameters", function () {
    it ("Check Token name", function(){
      return TokenInstance.name.call().then(function(res){
        console.log("Token name = " + res.toString());
        expect(res.toString()).to.be.equal(TokenName);
      })
    })
    it ("Check Token Symbol", function(){
      return TokenInstance.symbol.call().then(function(res){
        console.log("Token Symbol = " + res.toString());
        expect(res.toString()).to.be.equal(Symbol);
      })
    })
    it ("check Token Decimals", function(){
      return TokenInstance.decimals.call().then(function(res){
        console.log("Token decimals = " + res.toString());
        expect(parseInt(res.toString())).to.be.equal(Decimals);
      })
    })
  })

  describe ("Get tokenHolders addresses", function() {
    it ("check owner address", function(){
      return TokenInstance.owner.call().then(function(res){
        console.log("owner = "+ res.toString());
        owner = res.toString();
      })
    })
    it ("check reservedTokensAddress address", function(){
      return TokenInstance.reservedTokensAddress.call().then(function(res){
        console.log("reservedTokensAddress = "+ res.toString());
        reservedTokensAddress = res.toString();
        //hardcoded address
        expect(res.toString()).to.be.equal("0x82ea2755a38637dd20322378266bf01260d35c73");
      })
    })
    it ("check foundersTokensAddress address", function(){
      return TokenInstance.foundersTokensAddress.call().then(function(res){
        console.log("foundersTokensAddress = "+ res.toString());
        foundersTokensAddress = res.toString();
        //hardcoded address
        expect(res.toString()).to.be.equal("0xc47830de1dee63f8fcaa562bc5a78457a5dae819");
      })
    })
    it ("check advisorsTokensAddress address", function(){
      return TokenInstance.advisorsTokensAddress.call().then(function(res){
        console.log("advisorsTokensAddress = "+ res.toString());
        advisorsTokensAddress = res.toString();
        //hardcoded address
        expect(res.toString()).to.be.equal("0x19ebb94b0df82400cfdadfc4cbc77c3e1bad1304");
      })
    })
  })


  describe ("Check initial balances", function(){
    it ("check owner balance", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[0]).then(function(res){
        console.log(res.toString());
        // console.log(totalSupply);
        expect(res.toString()).to.be.equal((3650000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check reservedTokensAddress balance", function(){
      return TokenInstance.balanceOf(reservedTokensAddress).then(function(res){
        console.log(res.toString());
        // console.log(totalSupply);
        expect(res.toString()).to.be.equal((750000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check foundersTokensAddress balance", function(){
      return TokenInstance.balanceOf(foundersTokensAddress).then(function(res){
        console.log(res.toString());
        // console.log(totalSupply);
        expect(res.toString()).to.be.equal((450000000*Math.pow(10,Decimals)).toString());
      });
    });
    it ("check holded for advisorsTokensAddress in contract balance", function(){
      return TokenInstance.balanceOf(TokenInstance.address).then(function(res){
        console.log(res.toString());
        // console.log(totalSupply);
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)).toString());
      });
    });
  });

  describe ("Check privateSale stage", function (){
    it ("owner send 1000 tokens to another address, and lock 800 tokens", function(){
      return TokenInstance.privateSale(web3.eth.accounts[1], 1000*Math.pow(10,Decimals), 800*Math.pow(10,Decimals))
      .then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
    it ("check his token balance", function(){
      return (TokenInstance.balanceOf(web3.eth.accounts[1])).then(function(res){
        expect(res.toString()).to.be.equal((1000*Math.pow(10,Decimals)).toString());
      })
    })
    it ("check his lockes tokens", function(){
      return (TokenInstance.privateBonusLockedTokens(web3.eth.accounts[1])).then(function(res){
        expect(res.toString()).to.be.equal((800*Math.pow(10,Decimals)).toString());
      })
    })
    it ("try to release locked tokens (this transacion must failed)", async function(){
      try {
        await TokenInstance.releasePrivateLockToken(web3.eth.accounts[1])
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
  })

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

  describe ("increase EVM time", function(){
    it ("get blockTimestamp now", function(){
      console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
    })


    it("increse up to 121 days", function(){  
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [10454400], id: 0})
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
    })

    it ("get blockTimestamp again", function(){
      console.log(web3.eth.getBlock(web3.eth.blockNumber).timestamp);
    })

    it ("release privateLockTokens now", function(){
      return TokenInstance.releasePrivateLockToken(web3.eth.accounts[1]).then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })

    it("check his balance now", function(){
      return TokenInstance.balanceOf(web3.eth.accounts[1]).then(function(res){
        console.log(res.toString());
        expect(res.toString()).to.be.equal((1800*Math.pow(10,Decimals)).toString())
      })
    })
  })

  describe("release advisors tokens", function(){
    it ("calling releaseadvisorsTokensAddress function", function(){
      return TokenInstance.releaseadvisorsTokensAddress().then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })

    it ("check advisorsBalance now", function(){
      return TokenInstance.balanceOf(advisorsTokensAddress).then(function(res){
        console.log(res.toString());
        console.log((150000000*Math.pow(10,Decimals)/100*30).toString());
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)/100*30).toString())
      })
    })

    it ("try to call again (transacion must failed)", async function(){
      try {
        await TokenInstance.releaseadvisorsTokensAddress()
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })

    it ("increse time to 3d release", function(){
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [21600000], id: 0})
      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
    })

    it ("call releaseadvisorsTokensAddress", function(){
      return TokenInstance.releaseadvisorsTokensAddress().then(function(res){
        expect(res.toString()).to.not.be.an("error");
      })
    })
    it ("check advisorsBalance now", function(){
      return TokenInstance.balanceOf(advisorsTokensAddress).then(function(res){
        console.log(res.toString());
        console.log((150000000*Math.pow(10,Decimals)).toString());
        expect(res.toString()).to.be.equal((150000000*Math.pow(10,Decimals)).toString())
      })
    })

    it ("try to call again (transacion must failed)", async function(){
      try {
        await TokenInstance.releaseadvisorsTokensAddress()
        assert.ok(false, "It didn't fail")
      } catch(error){
        assert.ok(true, "It must failed");
      }
    })
  })
})