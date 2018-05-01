const assert = global.assert || {}
const artifacts = global.artifacts || {}
const contract = global.contract || {}
const it = global.it || {}
const describe = global.describe || {}
const before = global.before || {}

const ethers = require('ethers')

const StringLibrary = artifacts.require('./StringLibrary.sol')

contract('StringLibrary', accounts => {
  let library
  before(async () => {
    library = await StringLibrary.deployed()
  })
  describe('characters tests', () => {
    it('is a numbers', async () => {
      const library = await StringLibrary.deployed()
      console.log(library.address)
    })
  })
})