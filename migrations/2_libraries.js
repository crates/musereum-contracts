const NotSameStorage = artifacts.require('./NotSameStorage.sol')
const MockNotSameStorage = artifacts.require('./MockNotSameStorage.sol')

module.exports = function (deployer) {
  deployer.deploy(NotSameStorage)
  deployer.link(NotSameStorage, MockNotSameStorage)
}
