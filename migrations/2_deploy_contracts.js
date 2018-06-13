var ArawToken = artifacts.require("ArawToken");

var reservedTokensAddress = '0x82ea2755a38637dd20322378266bf01260d35c73';
var foundersTokensAddress = '0xc47830de1dee63f8fcaa562bc5a78457a5dae819';
var advisorsTokensAddress = '0x19ebb94b0df82400cfdadfc4cbc77c3e1bad1304';

var arawWalletAddress = '0x441455B4eA7cF900DDA364700F7872897B7A93cc';

module.exports = function(deployer) {
  deployer.deploy(ArawToken, reservedTokensAddress, foundersTokensAddress, advisorsTokensAddress, arawWalletAddress);
};