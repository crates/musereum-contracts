pragma solidity ^0.4.19;


contract Contract {
  struct ContextData {
    address sender;
    uint value;
  }

  address Resolver;
  ContextData internal Context;
}