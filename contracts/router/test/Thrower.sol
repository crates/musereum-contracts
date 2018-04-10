pragma solidity ^0.4.19;

contract Thrower {
  function throws() pure public {
    revert();
  }
}
