pragma solidity ^0.4.19;
import "./StandardLibrary.sol";
import "./StringLibrary.sol";
import "./AliasLibrary.sol";


interface IEntrance {
  function getOutsize(address _router, bytes4 _signature, bytes _data) view external returns (uint);
}

contract Contract {
  using StandardLibrary for *;
  using StringLibrary for *;
  using AliasLibrary for *;
  
  address public resolver;
  address public entrance;

  function Contract(address _entrance) public {
    require(_entrance != address(0x0));
    require(_entrance.isContract());
    entrance = _entrance;
  }

  modifier from_entrance() {
    require(msg.sender == entrance);
    _;
  }
}