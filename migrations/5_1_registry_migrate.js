const Entrance = artifacts.require('Entrance.sol')
const Resolver = artifacts.require('Resolver.sol')
const Router = artifacts.require('Router.sol')
const UserRegistry = artifacts.require('UserRegistry.sol')

// Libraries
const StandardLibrary = artifacts.require('./StandardLibrary.sol')
const StringLibrary = artifacts.require('./StringLibrary.sol')
const AliasLibrary = artifacts.require('./AliasLibrary.sol')

module.exports = function (deployer) {
  deployer.then(async () => {
    const entrance = await Entrance.deployed()

    await deployer.link(StandardLibrary, UserRegistry)
    await deployer.link(StringLibrary, UserRegistry)
    await deployer.link(AliasLibrary, UserRegistry)
    await deployer.deploy(UserRegistry, entrance.address)
    const registry = await UserRegistry.deployed()
    const resolver = await Resolver.new(registry.address)
    const router = await Router.new(resolver.address)

    await resolver.register('setAlias(address,string)', registry.address, 0)
    await resolver.register('linkWallet(address,address)', registry.address, 0)
    // await resolver.register('baseWallets(address)', registry.address, 32)
    await entrance.register('core.user-registry', router.address)
  })
}
