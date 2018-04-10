pragma solidity 0.4.21;

contract SenderChecker {
  function checkSender() constant public returns(address) {
    return msg.sender;
  }
}
