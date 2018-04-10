pragma solidity ^0.4.19;
import "./One.sol";

contract Two is One {
  uint two;
  
  function setTwo(uint _two) public {
    two = _two;
  }

  function getTwo() view public returns(uint) {
    return two;
  }
}
