import expectThrow from 'zeppelin-solidity/test/helpers/expectThrow'

const { utils } = require('ethers')
const ExternalStorage = artifacts.require('./ExternalStorage.sol')
const MockNotSameStorage = artifacts.require('./MockNotSameStorage.sol')

function keccakKey (raw) {
  return utils.solidityKeccak256([ 'string' ], [ raw ])
}

const buffer = utils.hexlify(utils.randomBytes(60))
const bytes32 = utils.hexlify(utils.randomBytes(32))
const key = keccakKey('42')

contract('Storage tests', ([coinbase]) => {
  let store

  describe('setup', () => {
    it('should create storage', async () => {
      store = await ExternalStorage.new()
    })

    it('should be empty', async () => {
      assert.isFalse(await store.getBool(key))
      assert.equal(0, await store.getUint(key))
      assert.equal(0, await store.getInt(key))
    })
  })

  describe('write', () => {
    it('should allow to write bool', async () => {
      await store.setBool(key, true)
    })
    it('should allow to write int', async () => {
      await store.setInt(key, 42)
    })
    it('should allow to write uint', async () => {
      await store.setUint(key, 42)
    })
    it('should allow to write string', async () => {
      await store.setString(key, '42')
    })
    it('should allow to write bytes', async () => {
      await store.setBytes(key, bytes32)
    })
    it('should allow to write buffer', async () => {
      await store.setBuffer(key, buffer)
    })
    it('should allow to write address', async () => {
      await store.setAddress(key, coinbase)
    })
  })

  describe('read', () => {
    it('should receive previously writen bool', async () => {
      assert.isTrue(await store.getBool(key))
    })
    it('should receive previously writen int', async () => {
      assert.equal(42, await store.getInt(key))
    })
    it('should receive previously writen uint', async () => {
      assert.equal(42, await store.getUint(key))
    })
    it('should receive previously writen string', async () => {
      assert.equal('42', await store.getString(key))
    })
    it('should receive previously writen bytes', async () => {
      assert.equal(bytes32, await store.getBytes(key))
    })
    it('should receive previously writen buffer', async () => {
      assert.equal(buffer, await store.getBuffer(key))
    })
    it('should receive previously writen address', async () => {
      assert.equal(coinbase, await store.getAddress(key))
    })
  })

  describe('rewrite tests', () => {
    let mock
    it('should move store to another owner', async () => {
      mock = await MockNotSameStorage.new(store.address)
      await store.transferOwnership(mock.address)
      assert.equal(mock.address, await store.owner())
    })
    it('should fail at rewrite same bool', async () => {
      await expectThrow(mock.setBool(key, true))
    })
    it('should fail at rewrite same int', async () => {
      await expectThrow(mock.setInt(key, 42))
    })
    it('should fail at rewrite same uint', async () => {
      await expectThrow(mock.setUint(key, 42))
    })
    it('should fail at rewrite same string', async () => {
      await expectThrow(mock.setString(key, '42'))
    })
    it('should fail at rewrite same bytes', async () => {
      await expectThrow(mock.setBytes(key, bytes32))
    })
    it('should fail at rewrite same buffer', async () => {
      await expectThrow(mock.setBuffer(key, buffer))
    })
    it('should fail at rewrite same address', async () => {
      await expectThrow(mock.setAddress(key, coinbase))
    })
  })
})
