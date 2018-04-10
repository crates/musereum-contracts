pragma solidity 0.4.21;

contract PayableContract {
  address resolver;
  uint public sentAmount;

  function payFunction() payable public {
    sentAmount = msg.value;
  }
}
