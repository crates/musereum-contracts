pragma solidity ^0.4.19;

import "../../standard/StandardLibrary.sol";
import "../../standard/StringLibrary.sol";
import "../../standard/AliasLibrary.sol";

contract MockLibraries {
  using StringLibrary for *;
  using StandardLibrary for *;
  using AliasLibrary for *;

  function testAliasSafe(string alias) pure public returns(bool) {
    return alias.isAliasSafe();
  }
}