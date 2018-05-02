pragma solidity ^0.4.19;
import "../standard/Contract.sol";


contract UserRegistry is Contract {
  mapping (address => address) public baseWallets;
  mapping (address => address[]) public linkedWallets;

  mapping (address => string) public walletAliases;
  mapping (bytes32 => address) public knownAliases;

  function UserRegistry(address _entrance) Contract(_entrance) public {}

  function getMainWallet(address wallet) public view returns (address) {
    address main = baseWallets[wallet];
    if (main == address(0x0)) {
      main = wallet;
    }
    return main;
  }

  function setAlias (address wallet, string alias) public {
    address main = getMainWallet(wallet);
    require(wallet != address(0x0));
    require(bytes(walletAliases[main]).length == 0);
    require(bytes(alias).length < 32);
    require(bytes(alias).length > 5);

    require(alias.isAliasSafe());
    require(alias.toSlice().len() < 32);

    walletAliases[wallet] = alias;
    knownAliases[keccak256(alias)] = wallet;
  }

  function linkWallet (address main, address extra) public {
    require(!extra.isContract());
    require(!main.isContract());
    require(baseWallets[extra] == address(0x0));

    baseWallets[extra] = main;
    linkedWallets[main].push(extra);
  }
}