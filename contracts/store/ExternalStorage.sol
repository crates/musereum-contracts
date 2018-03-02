pragma solidity 0.4.19;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";


/// @title The primary persistent storage for updatable contracts
/// @author Aler Denisov <aler.zampillo@gmail.com>
contract ExternalStorage is Ownable {
  // ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗    ███████╗██╗███████╗██╗     ██████╗ ███████╗
  // ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝    ██╔════╝██║██╔════╝██║     ██╔══██╗██╔════╝
  // ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗      █████╗  ██║█████╗  ██║     ██║  ██║███████╗
  // ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝      ██╔══╝  ██║██╔══╝  ██║     ██║  ██║╚════██║
  // ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗    ██║     ██║███████╗███████╗██████╔╝███████║
  // ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚═════╝ ╚══════╝                                                                                                              
  mapping(bytes32 => uint)       private uintStorage;
  mapping(bytes32 => address)    private addressStorage;
  mapping(bytes32 => string)     private stringStorage;
  mapping(bytes32 => bytes32)    private bytesStorage;
  mapping(bytes32 => bytes)      private bufferStorage;
  mapping(bytes32 => bool)       private boolStorage;
  mapping(bytes32 => int)        private intStorage;


  //  ██████╗ ███████╗████████╗████████╗███████╗██████╗ ███████╗
  // ██╔════╝ ██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
  // ██║  ███╗█████╗     ██║      ██║   █████╗  ██████╔╝███████╗
  // ██║   ██║██╔══╝     ██║      ██║   ██╔══╝  ██╔══██╗╚════██║
  // ╚██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████║
  //  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
  /// @param _key The key for the record
  /// @return address value stored at providen key
  function getAddress(bytes32 _key) public constant returns (address) {
    return addressStorage[_key];
  }

  /// @param _key The key for the record
  /// @return uint value stored at providen key
  function getUint(bytes32 _key) public constant returns (uint) {
    return uintStorage[_key];
  }

  /// @param _key The key for the record
  /// @return bytes32 value stored at providen key
  function getBytes(bytes32 _key) public constant returns (bytes32) {
    return bytesStorage[_key];
  }

  /// @param _key The key for the record
  /// @return bool value stored at providen key
  function getBool(bytes32 _key) public constant returns (bool) {
    return boolStorage[_key];
  }

  /// @param _key The key for the record
  /// @return int value stored at providen key
  function getInt(bytes32 _key) public constant returns (int) {
    return intStorage[_key];
  }

  /// @param _key The key for the record
  /// @return string value stored at providen key
  function getString(bytes32 _key) public constant returns (string) {
    return stringStorage[_key];
  }

  /// @param _key The key for the record
  /// @return bytes buffer stored at providen key
  function getBuffer(bytes32 _key) public constant returns (bytes) {
    return bufferStorage[_key];
  }

  // ███████╗███████╗████████╗████████╗███████╗██████╗ ███████╗
  // ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
  // ███████╗█████╗     ██║      ██║   █████╗  ██████╔╝███████╗
  // ╚════██║██╔══╝     ██║      ██║   ██╔══╝  ██╔══██╗╚════██║
  // ███████║███████╗   ██║      ██║   ███████╗██║  ██║███████║
  // ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAddress(bytes32 _key, address _value) onlyOwner public returns (bool) {
    if (addressStorage[_key] == _value) {
      return false;
    }

    addressStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setUint(bytes32 _key, uint _value) onlyOwner public returns (bool) {
    if (uintStorage[_key] == _value) {
      return false;
    }
    uintStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBytes(bytes32 _key, bytes32 _value) onlyOwner public returns (bool) {
    if (bytesStorage[_key] == _value) {
      return false;
    }
    bytesStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBool(bytes32 _key, bool _value) onlyOwner public returns (bool) {
    if (boolStorage[_key] == _value) {
      return false;
    }
    boolStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setInt(bytes32 _key, int _value) onlyOwner public returns (bool) {
    if (intStorage[_key] == _value) {
      return false;
    }
    intStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setString(bytes32 _key, string _value) onlyOwner public returns (bool) {
    uint providValueHash = uint(keccak256(_value));
    uint storedValueHash = uint(keccak256(stringStorage[_key]));
    if (providValueHash == storedValueHash) {
      return false;
    }

    stringStorage[_key] = _value;
    return true;
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBuffer(bytes32 _key, bytes _value) onlyOwner public returns (bool) {
    uint providValueHash = uint(keccak256(_value));
    uint storedValueHash = uint(keccak256(bufferStorage[_key]));
    if (providValueHash == storedValueHash) {
      return false;
    }

    bufferStorage[_key] = _value;
    return true;
  }
}
