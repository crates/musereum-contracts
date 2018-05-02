const assert = global.assert || {}
const artifacts = global.artifacts || {}
const contract = global.contract || {}
const it = global.it || {}
const describe = global.describe || {}
const before = global.before || {}

const ethers = require('ethers')

const MockLibraries = artifacts.require('./MockLibraries.sol')

contract('Aliases tests', accounts => {
  let library
  before(async () => {
    library = await MockLibraries.new()
  })
  describe('safe tests', () => {
    it('number is safe', async () => {
      assert.isTrue(await library.testAliasSafe('123'))
    })

    it('letters should be safe', async () => {
      assert.isTrue(await library.testAliasSafe('test'))
    })

    it('numbers and letters is safe', async () => {
      assert.isTrue(await library.testAliasSafe('test123'))
    })

    it('underscore is safe', async () => {
      assert.isTrue(await library.testAliasSafe('test_123'))
    })

    it('dash is sale', async () => {
      assert.isTrue(await library.testAliasSafe('test-123'))
    })

    it('space isnt safe', async () => {
      assert.isNotTrue(await library.testAliasSafe('test 1'))
    })

    it('non-latin characters isnt safe', async () => {
      assert.isNotTrue(await library.testAliasSafe('русский'))
    })

    it('special characters isnt safe', async () => {
      assert.isNotTrue(await library.testAliasSafe('?'))
      assert.isNotTrue(await library.testAliasSafe('.'))
      assert.isNotTrue(await library.testAliasSafe('!'))
      assert.isNotTrue(await library.testAliasSafe('@'))
      assert.isNotTrue(await library.testAliasSafe('^'))
      assert.isNotTrue(await library.testAliasSafe('()'))
    })

    it('alias more than 32 letters long isnt safe', async () => {
      assert.isNotTrue(await library.testAliasSafe(Array(32).fill('a').join('')))
      assert.isTrue(await library.testAliasSafe(Array(31).fill('a').join('')))
    })
  })
})
