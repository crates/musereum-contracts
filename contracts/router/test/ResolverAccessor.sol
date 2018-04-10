pragma solidity 0.4.21;
contract ResolverAccessor {
  address resolver;

  function getResolver() view public returns(address) {
    return resolver;
  }
}
