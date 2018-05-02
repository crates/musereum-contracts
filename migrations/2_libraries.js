const NotSameStorage = artifacts.require('./NotSameStorage.sol')
const MockNotSameStorage = artifacts.require('./MockNotSameStorage.sol')
const StandardLibrary = artifacts.require('./StandardLibrary.sol')
const StringLibrary = artifacts.require('./StringLibrary.sol')
const AliasLibrary = artifacts.require('./AliasLibrary.sol')

module.exports = function (deployer) {
  deployer.deploy(NotSameStorage)
  deployer.deploy(StandardLibrary)
  deployer.deploy(StringLibrary)
  deployer.deploy(AliasLibrary)
  deployer.link(NotSameStorage, MockNotSameStorage)
}
