pragma solidity 0.4.21;

contract Thrower {
  function throws() pure public {
    revert();
  }
}
