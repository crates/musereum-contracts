const assert = global.assert || {}
const artifacts = global.artifacts || {}
const contract = global.contract || {}
const it = global.it || {}
const describe = global.describe || {}

const ethers = require('ethers')
const nullAddress = '0x0000000000000000000000000000000000000000'
const UserRegistry = artifacts.require('UserRegistry.sol')
const Entrance = artifacts.require('./Entrance.sol')
const Router = artifacts.require('./Router.sol')
const Resolver = artifacts.require('./Resolver.sol')

String.prototype.keccak256 = function () {
  return ethers.utils.keccak256(ethers.utils.toUtf8Bytes(this))
}

contract('UserRegistry', ([main, extra, extra2, another, another2]) => {
  let entrance, instance
  const UserRegistryInterface = new ethers.Interface(UserRegistry.abi)

  before(async () => {
    entrance = await Entrance.deployed()
    instance = await UserRegistry.deployed()
  })

  describe('setup', () => {
    it('should be deployed', async () => {
      assert.isNotNull(instance)
    })

    it('should be available in entrance', async () => {
      assert.notEqual(nullAddress, await entrance.getRouter('core.user-registry'))
    })
  })

  describe('execute', () => {
    it('should link wallets', async () => {
      const linkTx = UserRegistryInterface.functions.linkWallet(main, extra)
      await web3.eth.sendTransaction({
        to: entrance.address,
        from: main,
        data: 'core.user-registry'.keccak256() + linkTx.data.substr(2),
        value: 0,
        gas: 3000000
      })
    })

    it('should know linked wallet', async () => {
      const mainWalletCall = UserRegistryInterface.functions.baseWallets(extra)
      const answer = mainWalletCall.parse(await web3.eth.call({
        from: main,
        to: entrance.address,
        value: 0,
        gas: 300000,
        data: 'core.user-registry'.keccak256() + mainWalletCall.data.substr(2)
      }))
      // const answer = mainWalletCall.parse(await web3.eth.call({
      //   to: instance.address,
      //   data: mainWalletCall.data
      // }))

      console.log(main, answer)
    })
  })
})
