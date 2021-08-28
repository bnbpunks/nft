var BNBPunks = artifacts.require("./BNBPunks.sol");

module.exports = function(deployer) {
  deployer.deploy(BNBPunks);
};
