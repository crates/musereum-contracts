pragma solidity ^0.4.19;
import "../standard/Contract.sol";


contract UserRegistry is Contract {
  mapping (address => address) public baseWallets;
  mapping (address => address[]) public linkedWallets;

  mapping (address => string) public walletAliases;
  mapping (string => address) public knownAliases;


  function setAlias (address wallet, string alias) public {
    require(alias.isAliasSafe());
    require(alias.length() < 32);

    walletAliases[wallet] = alias;
    knownAliases[alias] = wallet;
  }

  function linkWallet (address main, address extra) public {
    require(!extra.isContract());
    require(!main.isContract());

    baseWallets[extra] = main;
    linkedWallets[main].push(extra);
  }
}