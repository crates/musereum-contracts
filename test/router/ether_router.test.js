const assert = global.assert || {}
const artifacts = global.artifacts || {}
const contract = global.contract || {}
const it = global.it || {}
// const describe = global.describe || {}

const EtherRouter = artifacts.require('EtherRouter.sol')
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
const PayableContract = artifacts.require('PayableContract.sol')

contract('EtherRouter', function (accounts) {
  it('should be able to get back a return value', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeAnswer = TheAnswer.at(etherRouter.address)
        TheAnswer.deployed()
          .then(function (result) { return resolver.register('getAnswer()', result.address, 32) })
          .then(function () { return fakeAnswer.getAnswer() })
          .then(function () { return fakeAnswer.getAnswer.call() })
          .then(function (result) {
            assert.equal(result, 42)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should be able to pass along arguments', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeMultiplier = Multiplier.at(etherRouter.address)
        Multiplier.deployed()
          .then(function (result) { return resolver.register('multiply(uint256,uint256)', result.address, 32) })
          .then(function () { return fakeMultiplier.multiply.call(7, 3) })
          .then(function (result) {
            assert.equal(result, 21)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should be able to get multiple return values', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeLost = Lost.at(etherRouter.address)
        Lost.deployed()
          .then(function (result) { return resolver.register('getNumbers()', result.address, 192) })
          .then(function () { return fakeLost.getNumbers.call() })
          .then(function (result) {
            assert.equal(result[0], 4)
            assert.equal(result[1], 8)
            assert.equal(result[2], 15)
            assert.equal(result[3], 16)
            assert.equal(result[4], 23)
            assert.equal(result[5], 42)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should be able to store data', function (done) {
    var resolver
    var simpleStore

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeSimpleStore = SimpleStore.at(etherRouter.address)
        SimpleStore.deployed()
          .then(function (result) { simpleStore = result })
          .then(function (result) { return resolver.register('getStored()', simpleStore.address, 32) })
          .then(function (result) { return resolver.register('store(uint256)', simpleStore.address, 0) })
          .then(function () { return fakeSimpleStore.store(42) })
          .then(function () { return fakeSimpleStore.getStored.call() })
          .then(function (result) {
            assert.equal(result, 42)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should be able to read data on the contract', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeResolverAccessor = ResolverAccessor.at(etherRouter.address)
        ResolverAccessor.deployed()
          .then(function (result) { return resolver.register('getResolver()', result.address, 32) })
          .then(function () { return fakeResolverAccessor.getResolver.call() })
          .then(function (result) {
            assert.equal(result, resolver.address)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should keep its msg.sender', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeSenderChecker = SenderChecker.at(etherRouter.address)
        SenderChecker.deployed()
          .then(function (result) { return resolver.register('checkSender()', result.address, 32) })
          .then(function () { return fakeSenderChecker.checkSender.call() })
          .then(function (result) {
            assert.equal(result, accounts[0])
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should allow upgrades that add storage data', function (done) {
    var resolver
    var one
    var two

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeOne = One.at(etherRouter.address)
        var fakeTwo = Two.at(etherRouter.address)
        One.deployed()
          .then(function (result) { one = result })
          .then(function () { return Two.deployed() })
          .then(function (result) { two = result })
          .then(function () { return resolver.register('setOne(uint256)', one.address, 0) })
          .then(function () { return resolver.register('getOne()', one.address, 32) })
          .then(function () { return resolver.register('setTwo(uint256)', two.address, 0) })
          .then(function () { return resolver.register('getTwo()', two.address, 32) })
          .then(function () { return fakeOne.setOne(1) })
          .then(function () { return fakeTwo.setTwo(2) })
          .then(function () { return fakeOne.getOne.call() })
          .then(function (result) {
            assert.equal(result, 1)
          })
          .then(function () { return fakeTwo.getTwo.call() })
          .then(function (result) {
            assert.equal(result, 2)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should be able to use the fallback contract for unknown signatures', function (done) {
    var resolver
    var theAnswer

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeAnswer = TheAnswer.at(etherRouter.address)
        TheAnswer.deployed()
          .then(function (result) { theAnswer = result })
          .then(function () { return resolver.register('getAnswer()', 0, 0) })
          .then(function () { return resolver.setFallback(theAnswer.address) })
          .then(function () { return fakeAnswer.getAnswer.call() })
          .then(function (result) {
            assert.equal(result, 42)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should allow variable-return functions to lookup their return size if possible', function (done) {
    var key = 42
    var resolver
    var list

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeList = List.at(etherRouter.address)
        List.deployed()
          .then(function (result) { list = result })
          .then(function () { return resolver.register('setList(uint256,uint256[])', list.address, 0) })
          .then(function () { return resolver.register('getAll(uint256)', list.address, 0) })
          .then(function () { return resolver.registerLengthFunction('getAll(uint256)', 'getReturnSize(uint256)', list.address) })
          .then(function () { return fakeList.setList(key, [0, 1, 2, 3, 4, 5, 6]) })
          .then(function () { return fakeList.getAll.call(key) })
          .then(function (result) {
            assert.equal(result.length, 7)
            assert.equal(result[0], 0)
            assert.equal(result[1], 1)
            assert.equal(result[2], 2)
            assert.equal(result[3], 3)
            assert.equal(result[4], 4)
            assert.equal(result[5], 5)
            assert.equal(result[6], 6)
            done()
          }).catch(done)
      }).catch(done)
  })

  it('should propagate errors', function (done) {
    var resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakeThrower = Thrower.at(etherRouter.address)
        Thrower.deployed()
          .then(function (result) { return resolver.register('throws()', result.address, 0) })
          .then(function () { return fakeThrower.throws() })
          .then(assert.fail, function (err) { done() })
          .catch(done)
      }).catch(done)
  })

  it('should be able to pass ether to payable functions', function (done) {
    var resolver
    var payableContract

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return EtherRouter.new(resolver.address) })
      .then(function (etherRouter) {
        var fakePayable = PayableContract.at(etherRouter.address)
        PayableContract.deployed()
          .then(function (result) { payableContract = result })
          .then(function () { return resolver.setFallback(payableContract.address) })
          .then(function () { return fakePayable.payFunction({value: 10}) })
          .then(function () { return fakePayable.sentAmount.call() })
          .then(function (result) {
            assert.equal(result, 10)
            done()
          }).catch(done)
      }).catch(done)
  })
})
