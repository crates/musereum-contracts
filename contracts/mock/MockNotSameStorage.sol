pragma solidity 0.4.19;

import "../store/NotSameStorage.sol";
import "../store/ExternalStorage.sol";

contract MockNotSameStorage {
  using NotSameStorage for IExternalStore;

  IExternalStore extStorage;

  function MockNotSameStorage(address _extStorage) public {
    extStorage = IExternalStore(_extStorage);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setUint(bytes32 _key, uint _value) public {
    extStorage.setAnotherUint(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAddress(bytes32 _key, address _value) public {
    extStorage.setAnotherAddress(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBytes(bytes32 _key, bytes32 _value) public {
    extStorage.setAnotherBytes(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBool(bytes32 _key, bool _value) public {
    extStorage.setAnotherBool(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setInt(bytes32 _key, int _value) public {
    extStorage.setAnotherInt(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setString(bytes32 _key, string _value) public {
    extStorage.setAnotherString(_key, _value);
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setBuffer(bytes32 _key, bytes _value) public {
    extStorage.setAnotherBuffer(_key, _value);
  }
}