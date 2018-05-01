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

  /// @dev Extracts the first rune in the slice into `rune`, advancing the slice to point to the next rune and returning `rune`.
  /// @param self The slice to operate on.
  /// @param rune The slice that will contain the first rune.
  /// @return `rune`.
  function nextRune(slice self, slice rune) internal returns (slice) {
    rune._ptr = self._ptr;

    if (self._len == 0) {
      rune._len = 0;
      return rune;
    }

    uint len;
    uint b;
    // Load the first byte of the rune into the LSBs of b
    assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
    if (b < 0x80) {
      len = 1;
    } else if(b < 0xE0) {
      len = 2;
    } else if(b < 0xF0) {
      len = 3;
    } else {
      len = 4;
    }

    // Check for truncated codepoints
    if (len > self._len) {
      rune._len = self._len;
      self._ptr += self._len;
      self._len = 0;
      return rune;
    }

    self._ptr += len;
    self._len -= len;
    rune._len = len;
    return rune;
  }

  /// @dev Returns the first rune in the slice, advancing the slice to point to the next rune.
  /// @param self The slice to operate on.
  /// @return A slice containing only the first rune from `self`.
  function nextRune(slice self) internal returns (slice ret) {
    nextRune(self, ret);
  }
    
    function toChar(slice rune) internal returns (uint8, uint, string) {
        uint a;
        uint8 b;
        uint len;
        uint mask;
        
        // Extract binary from a slice and signature unicode byte
        assembly {
            a := mload(sub(mload(add(rune, 32)), 31))
            b := and(a, 0xFF)
        }
        
        if (b < 0x80) {
            len = 1;
            mask = 0xFF;
        } else if(b < 0xE0) {
            len = 2;
            mask = 0xFFFF;
        } else if(b < 0xF0) {
            len = 3;
            mask = 0xFFFFFF;
        } else {
            len = 4;
            mask = 0xFFFFFFFF;
        }
        
        uint char = a & mask;
        string memory ret = new string(len);
        uint retptr;
        assembly { retptr := add(ret, 32) }
        memcpy(retptr, rune._ptr, len);
        return (b, char, ret);
    }

  function runeIsDot(slice rune) pure internal returns (bool) {
    return toChar(rune) == 0x2e;
  }
  function runeIsMinus(slice rune) pure internal returns (bool) {
    return toChar(rune) == 0x2D;
  }
  function runeIsLowLine(slice rune) pure internal returns (bool) {
    return toChar(rune) == 0x5f;
  }
  function runeIsNumber(slice rune) pure internal returns (bool) {
    return toChar(rune) >= 0x30 && toChar(rune) <= 0x39;
  }
  function runeIsLetter(slice rune) pure internal returns (bool) {
    return (toChar(rune) >= 0x41 && toChar(rune) <= 0x5a) || (toChar(rune) >= 0x61 || toChar(rune) <= 0x7a);
  }
}