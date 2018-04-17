pragma solidity ^0.4.19;

/// @notice Musereum version of String Utils library based on https://github.com/Arachnid/solidity-stringutils
/// @dev StringLibrary is a part of standard library providen with Contract automaticly
/// @author Aler Denisov (aler.zampillo@gmail.com)
/// @author Nick Johnson (arachnid@notdot.net)
library StringLibrary {
  /// @notice base structure to manipulate with string in memory
  struct slice {
    uint _len;
    uint _ptr;
  }

  function memcpy(uint dest, uint src, uint len) private pure {
    // Copy word-length chunks while possible
    for(; len >= 32; len -= 32) {
      assembly {
        mstore(dest, mload(src))
      }
      dest += 32;
      src += 32;
    }

    // Copy remaining bytes
    uint mask = 256 ** (32 - len) - 1;
    assembly {
      let srcpart := and(mload(src), not(mask))
      let destpart := and(mload(dest), mask)
      mstore(dest, or(destpart, srcpart))
    }
  }

  /// @notice Returns a slice containing the entire string.
  /// @param self The string to make a slice from.
  /// @return A newly allocated slice containing the entire string.
  function toSlice(string self) pure internal returns (slice) {
    uint ptr;
    assembly {
      ptr := add(self, 0x20)
    }
    return slice(bytes(self).length, ptr);
  }

  /// @notice Calculates and returns length of providen string
  /// @param input The string to calculate length
  /// @return Length of providen string
  function length(string input) pure internal returns (uint) {
    return length(toSlice(input));
  }

  
  function length(slice self) pure internal returns (uint l) {
      // Starting at ptr-31 means the LSB will be the byte we care about
      uint ptr = self._ptr - 31;
      uint end = ptr + self._len;
      for (l = 0; ptr < end; l++) {
          uint8 b;
          assembly { b := and(mload(ptr), 0xFF) }
          if (b < 0x80) {
              ptr += 1;
          } else if(b < 0xE0) {
              ptr += 2;
          } else if(b < 0xF0) {
              ptr += 3;
          } else if(b < 0xF8) {
              ptr += 4;
          } else if(b < 0xFC) {
              ptr += 5;
          } else {
              ptr += 6;
          }
      }
  }

  function charIsDot(uint8 char) pure internal returns (bool) {
    return char == 0x2e;
  }
  function charIsMinus(uint8 char) pure internal returns (bool) {
    return char == 0x2D;
  }
  function charIsLowLine(uint8 char) pure internal returns (bool) {
    return char == 0x5f;
  }
  function charIsNumber(uint8 char) pure internal returns (bool) {
    return char >= 0x30 && char <= 0x39;
  }
  function charIsLetter(uint8 char) pure internal returns (bool) {
    return (char >= 0x41 && char <= 0x5a) || (char >= 0x61 || char <= 0x7a);
  }
}