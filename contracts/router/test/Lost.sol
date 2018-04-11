pragma solidity ^0.4.19;


contract Lost {
  function getNumbers() pure public returns(uint, uint, uint, uint, uint, uint) {
    return (4, 8, 15, 16, 23, 42);
  }
}
