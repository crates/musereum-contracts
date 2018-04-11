pragma solidity ^0.4.19;


contract ResolverAccessor {
  address resolver;

  function getResolver() view public returns(address) {
    return resolver;
  }
}
