const Entrance = artifacts.require('Entrance.sol')

module.exports = function (deployer) {
  deployer.deploy(Entrance)
}
