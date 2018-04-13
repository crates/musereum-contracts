pragma solidity ^0.4.19;
import "./Resolver.sol";

/// @notice Router is wrapper for each contract of network
/// @dev Provides way to proxy calls to contract implementation and allows to update them
/// @author Peter Borah <peterborah@gmail.com>
/// @author Aler Denisov <aler.zampillo@gmail.com>
// solium-disable security/no-inline-assembly
contract Router {
  Resolver resolver;

  /// @notice Construction function requires initial resolver
  /// @param _resolver Address of target resolver
  function Router(Resolver _resolver) public {
    resolver = _resolver;
  }

  /// @notice lookup function returns address of current implementation and size of output
  /// @param sig is 4 bytes long signature of calling method in contract (ex: `bytes4(keccak256('foo(uint)'))`)
  /// @return {
  ///   "address": address of stored in resolver implementation
  ///   "uint": size of output
  /// }
  function lookup(bytes4 sig, bytes data) public returns (address, uint) {
    return resolver.lookup(sig, data);
  }

  /// @notice custom fallback function to route calls to resolved implementation
  /// @dev awaiting for standard call data (starts with 4 bytes long signature and ends with arguments)
  function() payable public {
    uint r;
    // Get routing information for the called function
    address destination;
    uint outsize;
    
    (destination, outsize) = lookup(msg.sig, msg.data);

    // Make the call
    assembly {
      calldatacopy(mload(0x40), 0, calldatasize)
      r := delegatecall(sub(gas, 700), destination, mload(0x40), calldatasize, mload(0x40), outsize)
    }

    // Throw if the call failed
    if (r != 1) { 
      revert();
    }

    // Pass on the return value
    assembly {
      return(mload(0x40), outsize)
    }
  }
}
