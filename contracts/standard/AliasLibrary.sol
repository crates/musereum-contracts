pragma solidity ^0.4.19;
import "./StringLibrary.sol";


library AliasLibrary {
  using StringLibrary for *;

  function isAliasSafe(string input) pure internal returns (bool) {
    StringLibrary.slice memory slice = input.toSlice();
    
    if (slice._len >= 32) {
      return false;
    }

    uint ptr = slice._ptr - 31;
    uint end = ptr + slice._len;
    while (ptr < end) {
      uint8 b;
      assembly {
        b := and(mload(ptr), 0xFF)
      }

      // only ascii symbols is allowed
      if (charIsNumber(b) || 
          charIsLetter(b) || 
          charIsLowLine(b) || 
          charIsMinus(b)) 
      {
        ptr += 1;
        continue;
      }
      
      return false;
    }

    return true;
  }

  function charIsDot(uint8 char) pure private returns (bool) {
    return char == 0x2e;
  }

  function charIsMinus(uint8 char) pure private returns (bool) {
    return char == 0x2D;
  }

  function charIsLowLine(uint8 char) pure private returns (bool) {
    return char == 0x5f;
  }

  function charIsNumber(uint8 char) pure private returns (bool) {
    return char >= 0x30 && char <= 0x39;
  }

  function charIsLetter(uint8 char) pure private returns (bool) {
    return (char >= 0x41 && char <= 0x5a) || (char >= 0x61 && char <= 0x7a);
  }
}