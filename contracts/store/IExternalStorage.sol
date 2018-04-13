pragma solidity ^0.4.19;


interface IExternalStorage {
  function setAddress(bytes32 _key, address _value) public returns (bool);
  function setUint(bytes32 _key, uint _value) public returns (bool);
  function setBytes(bytes32 _key, bytes32 _value) public returns (bool);
  function setBool(bytes32 _key, bool _value) public returns (bool);
  function setInt(bytes32 _key, int _value) public returns (bool);
  function setString(bytes32 _key, string _value) public returns (bool);
  function setBuffer(bytes32 _key, bytes _value) public returns (bool);

  
  function getAddress(bytes32 _key) view public returns (address);
  function getUint(bytes32 _key) view public returns (uint);
  function getBytes(bytes32 _key) view public returns (bytes32);
  function getBool(bytes32 _key) view public returns (bool);
  function getInt(bytes32 _key) view public returns (int);
  function getString(bytes32 _key) view public returns (string);
  function getBuffer(bytes32 _key) view public returns (bytes);
}