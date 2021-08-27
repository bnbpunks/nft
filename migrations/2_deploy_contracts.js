var ConvertLib = artifacts.require("./ConvertLib.sol");
var BNBPunks = artifacts.require("./BNBPunks.sol");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, BNBPunks);
  deployer.deploy(BNBPunks);
};
