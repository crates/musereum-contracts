pragma solidity ^0.4.19;
import "../router/Resolver.sol";


// solium-disable security/no-inline-assembly
contract Entrance {
  mapping (bytes32 => address) public resolvers;

  function () public {
    bytes32 aliasHash;
    uint result;
    Resolver resolver;
    address destination;
    uint outsize;
    bytes4 signature;
    assembly {
      aliasHash := calldataload(0)
      signature := calldataload(32)
    }

    resolver = Resolver(resolvers[aliasHash]);
    (destination, outsize) = resolver.lookup(signature, msg.data);

    assembly {
      let size := sub(calldatasize, 32)
      calldatacopy(mload(0x40), 32, size)
      result := call(
        sub(gas, 700), 
        destination,
        callvalue,
        mload(0x40),
        size, 
        mload(0x40), 
        outsize)
    }
    // Throw if the call failed
    if (result != 1) { 
      revert();
    }
    // Pass on the return value
    assembly {
      return(mload(0x40), outsize)
    }
  }

  function register(string _alias, address _resolver) public {
    bytes32 aliasHash = keccak256(_alias);
    require(resolvers[aliasHash] == address(0x0));
    resolvers[aliasHash] = _resolver;
  }

  function getResolver(string _alias) view public returns (address) {
    bytes32 aliasHash = keccak256(_alias);
    return resolvers[aliasHash];
  }
}