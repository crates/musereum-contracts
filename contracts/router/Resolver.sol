pragma solidity ^0.4.19;

contract Resolver {
  struct Pointer { address destination; uint outsize; }
  mapping (bytes4 => Pointer) public pointers;
  address public fallback;
  address public admin;
  Resolver public replacement;

  struct LengthPointer { bytes4 sig; address destination; }
  mapping (bytes4 => LengthPointer) public lengthPointers;

  event FallbackChanged(address oldFallback, address newFallback); 

  modifier onlyAdmin {
    if (msg.sender != admin) { revert(); }
    _;
  }

  function Resolver(address _fallback) public {
    admin = msg.sender;
    fallback = _fallback;
  }

  // Public API
  function lookup(bytes4 sig, bytes msgData) public returns(address, uint) {
    if (address(replacement) != 0) { return replacement.lookup(sig, msgData); } // If Resolver has been replaced, pass call to replacement

    return (destination(sig, msgData), outsize(sig, msgData));
  }

  // Administrative functions

  function setAdmin(address _admin) onlyAdmin public {
    admin = _admin;
  }

  function replace(Resolver _replacement) onlyAdmin public {
    replacement = _replacement;
  }

  function register(string signature, address destination, uint outsize) onlyAdmin public {
    pointers[stringToSig(signature)] = Pointer(destination, outsize);
  }

  function registerLengthFunction(string mainSignature, string lengthSignature, address destination) onlyAdmin public {
    lengthPointers[stringToSig(mainSignature)] = LengthPointer(stringToSig(lengthSignature), destination);
  }

  function setFallback(address _fallback) onlyAdmin public {
    FallbackChanged(fallback, _fallback);
    fallback = _fallback;
  }

  // Helpers
  function destination(bytes4 sig, bytes msgData) view public returns(address) {
    msgData;

    address storedDestination = pointers[sig].destination;
    if (storedDestination != 0) {
      return storedDestination;
    } else {
      return fallback;
    }
  }

  function outsize(bytes4 sig, bytes msgData) public returns(uint) {
    if (lengthPointers[sig].destination != 0) {
      // Dynamically sized
      return dynamicLength(sig, msgData);
    } else if (pointers[sig].destination != 0) {
      // Stored destination and outsize
      return pointers[sig].outsize;
    } else {
      // Default
      return 32;
    }
  }

  function dynamicLength(bytes4 sig, bytes msgData) public returns(uint size) {
    msgData;
    uint r;
    address lengthDestination = lengthPointers[sig].destination;
    bytes4 lengthSig = lengthPointers[sig].sig;

    assembly {
      mstore(mload(0x40), lengthSig)
      calldatacopy(add(4, mload(0x40)), 4, sub(calldatasize, 4))
      r := delegatecall(sub(gas, 700), lengthDestination, mload(0x40), calldatasize, mload(0x40), 32)
      size := mul(mload(0x40), 32)
    }

    // Throw if the call failed
    if (r != 1) {
      revert();
    }
  }

  function stringToSig(string signature) pure public returns(bytes4) {
    return bytes4(keccak256(signature));
  }
}
