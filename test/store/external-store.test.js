const { utils } = require('ethers')
const ExternalStorage = artifacts.require('./ExternalStorage.sol')

function keccakKey (raw) {
  return utils.solidityKeccak256([ 'string' ], [ raw ])
}

const buffer = utils.hexlify(utils.randomBytes(60))
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
    it('should allow to write buffer', async () => {
      await store.setBuffer(key, buffer)
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
    it('should receive previously writen bytes', async () => {
      assert.equal('42', await store.getString(key))
    })
    it('should receive previously writen buffer', async () => {
      assert.equal(buffer, await store.getBuffer(key))
    })
  })
})
