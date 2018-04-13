const contract = global.contract || {}
const describe = global.describe || {}
const before = global.before || {}
// const after = global.after || {}
const it = global.it || {}
const assert = global.assert || {}
const artifacts = global.artifacts || {}

const expectThrow = require('../helpers/expectThrow')

const Entrance = artifacts.require('./Entrance.sol')
const Resolver = artifacts.require('./Resolver.sol')
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

const ethers = require('ethers')

const nullAddress = '0x0000000000000000000000000000000000000000'

String.prototype.keccak256 = function () {
  return ethers.utils.keccak256(ethers.utils.toUtf8Bytes(this))
}

contract('Entrance', () => {
  let entrance

  before(async () => {
    entrance = await Entrance.deployed()
  })

  describe('setup', () => {
    it('should be deployed', async () => {
      assert(entrance)
    })

    it('should returns null resolver', async () => {
      assert.equal(nullAddress, await entrance.getResolver('test'))
    })

    it('should allow to register router', async () => {
      const resolver = await Resolver.new(0)
      await entrance.register('test', resolver.address)
    })

    it('shoudl returns not null resolver', async () => {
      assert.notEqual(nullAddress, await entrance.getResolver('test'))
    })

    it('should have expected hash', async () => {
      assert.notEqual(nullAddress, await entrance.resolvers('test'.keccak256()))
    })

    it('should reject registration with already exists alias', async() => {
      // Create new resolver instance
      const resolver = await Resolver.new(0)
      await expectThrow(entrance.register('test', resolver.address))
    })

    it('should register answer contract', async () => {
      const resolver = await Resolver.new(0)
      const answer = await TheAnswer.deployed()
      await resolver.register('getAnswer()', answer.address, 32)
      await entrance.register('answer', resolver.address)
      console.log(resolver.address)
    })

    it('should have asnwer resolver', async () => {
      assert.notEqual(nullAddress, await entrance.getResolver('answer'))
      assert.notEqual(nullAddress, await entrance.resolvers('answer'.keccak256()))
      assert.notEqual(nullAddress, await entrance.resolvers('0x72713d2d8ce8ee141e4e6c2cea57d07d08f80cf040c0785cb486d47981c38657'))

      console.log('answer resolver is:', await entrance.resolvers('0x72713d2d8ce8ee141e4e6c2cea57d07d08f80cf040c0785cb486d47981c38657'))
    })

    it('should answer is expected', async () => {
      const answerContract = await TheAnswer.deployed()
      console.log(`Answer implementation address: ${answerContract.address}`)
      const answer = await answerContract.getAnswer()
      assert.equal(42, answer.toNumber())
    })
  })

  describe('call validation', () => {
    it('should call answer', async () => {
      const answerInterface = new ethers.Interface(TheAnswer.abi)
      const answerCall = answerInterface.functions.getAnswer()
      const callData = 'answer'.keccak256() + answerCall.data.substr(2)

      console.log(`original data is ${answerCall.data}`)
      console.log(`original hash is ${'answer'.keccak256()}`)
      console.log(`original call data is ${callData}`)

      const answer = answerCall.parse(await web3.eth.call({
        to: entrance.address,
        data: callData
      }))

      assert.equal(42, answer)
    })

    it('should be able to pass along arguments', async () => {
      const resolver = await Resolver.new(0)
      const multiplier = await Multiplier.deployed()
      await resolver.register('multiply(uint256,uint256)', multiplier.address, 32)
      await entrance.register('multiplier', resolver.address)

      const multiplierInterface = new ethers.Interface(Multiplier.abi)
      const multiplierCall = multiplierInterface.functions.multiply(7, 3)
      const callData = 'multiplier'.keccak256() + multiplierCall.data.substr(2)

      const answer = multiplierCall.parse(await web3.eth.call({
        to: entrance.address,
        data: callData
      }))

      assert.equal(21, answer)
    })

    it('should be able to get multiple return values', async () => {
      const resolver = await Resolver.new(0)
      const lost = await Lost.deployed()
      await resolver.register('getNumbers()', lost.address, 192)
      await entrance.register('lost', resolver.address)

      const lostInterface = new ethers.Interface(Lost.abi)
      const lostCall = lostInterface.functions.getNumbers()
      const callData = 'lost'.keccak256() + lostCall.data.substr(2)

      const answer = lostCall.parse(await web3.eth.call({
        to: entrance.address,
        data: callData
      }))

      
      assert.equal(answer[0].toNumber(), 4)
      assert.equal(answer[1].toNumber(), 8)
      assert.equal(answer[2].toNumber(), 15)
      assert.equal(answer[3].toNumber(), 16)
      assert.equal(answer[4].toNumber(), 23)
      assert.equal(answer[5].toNumber(), 42)

      // console.log(answer)
      // console.log(lostCall.parse(answer))
    })

    it('should be able to register store contract', async () => {
      const resolver = await Resolver.new(0)
      const store = await SimpleStore.deployed()
      await resolver.register('store(uint256)', store.address, 0)
      await resolver.register('getStored()', store.address, 32)
      await entrance.register('store', resolver.address)
    })

    it('should be able to store data', async () => {
      const storeInterface = new ethers.Interface(SimpleStore.abi)
      const storeTx = storeInterface.functions.store(42)
      const storeTxData = 'store'.keccak256() + storeTx.data.substr(2)
      await web3.eth.sendTransaction({
        from: web3.eth.accounts[0],
        to: entrance.address,
        value: 0,
        data: storeTxData,
        gas: 300000
      })
    })

    it('should be able to restore data', async () => {
      const storeInterface = new ethers.Interface(SimpleStore.abi)
      const restoreCall = storeInterface.functions.getStored()
      const restoreCallData = 'store'.keccak256() + restoreCall.data.substr(2)
      const answer = restoreCall.parse(await web3.eth.call({
        to: entrance.address,
        data: restoreCallData
      }))

      assert.equal(answer[0].toNumber(), 42)
    })
  })

  // describe('test', () => {
  //   it('should return input string', async () => {
  //     const aInstance = await A.new()

  //     await aInstance.store('😀')
  //     const aInterface = new ethers.Interface(A.abi)
  //     const aCall = aInterface.functions.output()

  //     const answer = await web3.eth.call({
  //       to: aInstance.address,
  //       data: aCall.data
  //     })

  //     console.log(answer, ethers.utils.toUtf8String(answer))
  //     assert.equal('😀', ethers.utils.toUtf8String(answer))
  //   })

  //   it('should return from another contract', async () => {
  //     const bInstance = await B.new()
  //     await bInstance.store('Some string to store')
  //     const bCall = new ethers.Interface(B.abi).functions.restore()

  //     const answer = await web3.eth.call({
  //       to: bInstance.address,
  //       data: bCall.data
  //     })

  //     console.log(answer, ethers.utils.toUtf8String(answer))
  //     assert.equal('Some string to store', ethers.utils.toUtf8String(answer))
  //   })
})
