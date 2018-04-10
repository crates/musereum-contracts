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
      const entranceInterface = new ethers.Interface(Entrance.abi)

      // const { data: entranceSignature } = entranceInterface.functions.entrance()
      const answerCall = answerInterface.functions.getAnswer()
      const callData = 'answer'.keccak256() + answerCall.data.substr(2)

      console.log(`original data is ${answerCall.data}`)
      console.log(`original hash is ${'answer'.keccak256()}`)
      console.log(`original call data is ${callData}`)

      const tx = await entrance.sendTransaction({
        value: 0,
        data: callData,
        gas: '3000000'
      })

      const answer = await web3.eth.call({
        to: entrance.address,
        data: callData,
        gas: '300000'
      })

      console.log(`extracted data is ${answerCall.parse(answer)}`)

      assert.fail()

      // console.log(await entrance.Call({
      //   data: callData
      // }))
      // const answer = await entrance.call('answer'.keccak256())
      // assert.equal(42, answer)
    })
  })

  describe('call execution', () => {

  })
})