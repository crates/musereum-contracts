const assert = global.assert || {}
const artifacts = global.artifacts || {}
const contract = global.contract || {}
const it = global.it || {}

const Router = artifacts.require('Router.sol')
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

let resolver

contract('Resolver', function (accounts) {
  it("shouldn't allow non-admins to change the fallback function", function (done) {
    const fallback = Resolver.deployed().address

    Resolver.new(fallback)
      .then(function (newResolver) { resolver = newResolver })
      .then(function () { return resolver.setFallback(accounts[1], {from: accounts[2]}) })
      .then(assert.fail, function (err) { done() })
      .catch(done)
  })

  it("shouldn't allow non-admins to register functions", function (done) {
    Resolver.new(0)
      .then(function (newResolver) { resolver = newResolver })
      .then(function () { return resolver.register('foo', 0, 0, {from: accounts[2]}) })
      .then(assert.fail, function (err) { done() })
      .catch(done)
  })

  it("shouldn't allow non-admins to register length functions", function (done) {
    Resolver.new(0)
      .then(function (newResolver) { resolver = newResolver })
      .then(function () { return resolver.registerLengthFunction('foo', 'bar', 0, {from: accounts[2]}) })
      .then(assert.fail, function (err) { done() })
      .catch(done)
  })

  it("shouldn't allow non-admins to change admin", function (done) {
    Resolver.new(0)
      .then(function (newResolver) { resolver = newResolver })
      .then(function () { return resolver.setAdmin(accounts[1], {from: accounts[2]}) })
      .then(assert.fail, function (err) { done() })
      .catch(done)
  })

  it('should allow the admin to change the admin', function (done) {
    Resolver.new(0)
      .then(function (newResolver) { resolver = newResolver })
      .then(function () { return resolver.setAdmin(accounts[1]) })
      .then(function () { return resolver.admin() })
      .then(function (result) {
        assert.equal(result, accounts[1])
        done()
      }).catch(done)
  })

  it('should allow itself to be replaced by a newer version', function (done) {
    let firstResolver
    let secondResolver
    let fakeAnswer

    Resolver.new(TheAnswer.address)
      .then(function (result) { firstResolver = result })
      .then(function () { return Resolver.new(TheNextAnswer.address) })
      .then(function (result) { secondResolver = result })
      .then(function () { return Router.new(firstResolver.address) })
      .then(function (result) { fakeAnswer = TheAnswer.at(result.address) })
      .then(function () { return fakeAnswer.getAnswer() })
      .then(function (result) {
        assert.equal(result, 42)
      })
      .then(function () { return firstResolver.replace(secondResolver.address) })
      .then(function () { return fakeAnswer.getAnswer() })
      .then(function (result) {
        assert.equal(result, 43)
        done()
      }).catch(done)
  })

  it('should not allow anyone but admin to set a replacement', function (done) {
    let resolver

    Resolver.new(0)
      .then(function (result) { resolver = result })
      .then(function () { return resolver.replace(accounts[1], {from: accounts[2]}) })
      .then(assert.fail, function (err) { done() })
      .catch(done)
  })
})
