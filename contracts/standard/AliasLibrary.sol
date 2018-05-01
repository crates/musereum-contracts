pragma solidity ^0.4.19;
import "./StringLibrary.sol";


library AliasLibrary {
  using StringLibrary for *;

  function isAliasSafe(string input) pure internal returns (bool) {
    StringLibrary.slice memory slice = input.toSlice();

    uint ptr = slice._ptr - 31;
    uint end = ptr + slice._len;
    while (ptr < end) {
      uint8 b;
      assembly { b := and(mload(ptr), 0xFF) }
      if (b.charIsNumber() || b.charIsLetter()) {
      // if (b.charIsDot() || b.charIsNumber() || b.charIsLetter() || b.charIsLowLine() || b.charIsMinus()) {
        ptr += 1;
      } else {
        return false;
      }
    }

    return true;
  }
}