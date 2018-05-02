pragma solidity ^0.4.19;

library StandardLibrary {

  function isContract(address adr) view public returns (bool) {
    uint codeLength;

    assembly {
      codeLength := extcodesize(adr)
    }

    return codeLength > 0;
  }

  function toSignature(string sig) pure public returns (bytes4) {
    return bytes4(stringToHash(sig));
  }

  function stringToHash(string input) pure public returns (bytes32) {
    return keccak256(input);
  }

  function entranceCall(
    address entrance, 
    bytes32 aliasHash, 
    bytes data) public 
  {
    uint result;
    uint size = 32 + data.length;
    assembly {
      result := call(
        sub(gas, 700), 
        entrance,
        callvalue,
        aliasHash,
        size, 
        mload(0x40),
        32)
    }
    // Throw if the call failed
    if (result != 1) { 
      revert();
    }

    // Pass on the return value
    assembly {
      return(mload(0x40), 32)
    }
  }
}