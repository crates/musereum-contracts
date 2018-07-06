pragma solidity ^0.4.19;
import "./StandardLibrary.sol";
import "./StringLibrary.sol";
import "./AliasLibrary.sol";


interface IEntrance {
  function getOutsize(address _router, bytes4 _signature, bytes _data) view external returns (uint);
}


// solium-disable security/mixedcase
contract Contract {
  using StandardLibrary for *;
  using StringLibrary for *;
  using AliasLibrary for *;
  
  address public resolver;
  address public entrance;
  
  modifier from_entrance() {
    require(msg.sender == entrance);
    _;
  }
  
  function _get_addresses() public view returns (address, address, address, address) {
    return (msg.sender, entrance, resolver, tx.origin);
  }
}