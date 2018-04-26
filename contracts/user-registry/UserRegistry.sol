pragma solidity ^0.4.19;
import "../standard/Contract.sol";


contract UserRegistry is Contract {
  mapping (address => address) public baseWallets;
  mapping (address => address[]) public linkedWallets;

  mapping (address => string) public walletAliases;
  mapping (bytes32 => address) public knownAliases;

  function UserRegistry(address _entrance) Contract(_entrance) {}

  function setAlias (address wallet, string alias) public {
    require(alias.isAliasSafe());
    require(alias.length() < 32);

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