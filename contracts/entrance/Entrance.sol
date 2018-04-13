pragma solidity ^0.4.19;
import "../router/Router.sol";

/// @notice Entrance is core contract to communicate with Musereum network
/// @dev Each transaction or call should be passed through Entrance contract with hashed alias of target contract
/// @dev Another dev string :D
/// @author Aler Denisov <aler.zampillo@gmail.com>
// solium-disable security/no-inline-assembly
contract Entrance {
  /// @notice Map of known routers
  /// @dev Key is hash of alias (`keccak256(alias)`)
  mapping (bytes32 => address) public routers;

  /// @notice Custom fallback function to catch any call and tx
  /// @dev Awaiting for data with strict syntax: 0-32 bytes is hash of alias, 32+ tx\call data
  /// @dev Ex: `keccak256('fooContract') + bytes4('bar(uint)') + abi_encoded(42)`
  /// @dev To call **bar** function with 42 as argument in contract with alias **fooContract** 
  function () payable public {
    bytes32 aliasHash;
    uint result;
    Router router;
    address destination;
    uint outsize;
    bytes4 signature;
    
    // Extract alias and tx\call signature from calldata
    assembly {
      aliasHash := calldataload(0)
      signature := calldataload(32)
    }

    // find target router or throws
    require(routers[aliasHash] != address(0x0));
    router = Router(routers[aliasHash]);

    // lookup for output size
    (destination, outsize) = router.lookup(signature, msg.data);

    // making low-level call to target router with `call` op
    assembly {
      let size := sub(calldatasize, 32)
      calldatacopy(mload(0x40), 32, size)
      result := call(
        sub(gas, 700), 
        router,
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

  /// @notice register function is endpoint to add contract as known
  /// TODO: add rights check and ballot execution
  function register(string _alias, address _router) public {
    bytes32 aliasHash = keccak256(_alias);
    require(routers[aliasHash] == address(0x0));
    routers[aliasHash] = _router;
  }

  /// @notice getRouter returns address of known contract with providen alias (null address overwise)
  /// @param _alias human readable string of contract alias
  /// @return address for known contract
  function getRouter(string _alias) view public returns (address) {
    bytes32 aliasHash = keccak256(_alias);
    return routers[aliasHash];
  }
}