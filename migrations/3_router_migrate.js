const Resolver = artifacts.require('Resolver.sol')
const TheAnswer = artifacts.require('TheAnswer.sol')
const Multiplier = artifacts.require('Multiplier.sol')
const Lost = artifacts.require('Lost.sol')
const SimpleStore = artifacts.require('SimpleStore.sol')
const ResolverAccessor = artifacts.require('ResolverAccessor.sol')
const SenderChecker = artifacts.require('SenderChecker.sol')
const One = artifacts.require('One.sol')
const Two = artifacts.require('Two.sol')
const List = artifacts.require('List.sol')
const Thrower = artifacts.require('Thrower.sol')
const TheNextAnswer = artifacts.require('TheNextAnswer.sol')
const PayableContract = artifacts.require('PayableContract.sol')

module.exports = function (deployer) {
  deployer.deploy(Resolver, 0)
  deployer.deploy([
    TheAnswer,
    Multiplier,
    Lost,
    SimpleStore,
    ResolverAccessor,
    SenderChecker,
    One,
    Two,
    List,
    Thrower,
    TheNextAnswer,
    PayableContract
  ])
}
