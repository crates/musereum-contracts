pragma solidity ^0.4.19;

import "../../standard/StandardLibrary.sol";
import "../../standard/StringLibrary.sol";

contract MockLibraries {
  using StringLibrary for *;
  using StandardLibrary for *;

  function charIsDot(uint8 char) pure public returns (bool) {
    return char == 0x2e;
  }
  function charIsMinus(uint8 char) pure public returns (bool) {
    return char == 0x2D;
  }
  function charIsLowLine(uint8 char) pure public returns (bool) {
    return char == 0x5f;
  }
  function charIsNumber(uint8 char) pure public returns (bool) {
    return char >= 0x30 && char <= 0x39;
  }
  function charIsLetter(uint8 char) pure public returns (bool) {
    return (char >= 0x41 && char <= 0x5a) || (char >= 0x61 || char <= 0x7a);
  }
}