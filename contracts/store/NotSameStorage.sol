pragma solidity ^0.4.18;
import "./IExternalStorage.sol";


library NotSameStorage {
  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherUint(IExternalStorage externalStore, bytes32 _key, uint _value) public {
    require(externalStore.setUint(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherAddress(IExternalStorage externalStore, bytes32 _key, address _value) public {
    require(externalStore.setAddress(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBytes(IExternalStorage externalStore, bytes32 _key, bytes32 _value) public {
    require(externalStore.setBytes(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBool(IExternalStorage externalStore, bytes32 _key, bool _value) public {
    require(externalStore.setBool(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherInt(IExternalStorage externalStore, bytes32 _key, int _value) public {
    require(externalStore.setInt(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherString(IExternalStorage externalStore, bytes32 _key, string _value) public {
    require(externalStore.setString(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBuffer(IExternalStorage externalStore, bytes32 _key, bytes _value) public {
    require(externalStore.setBuffer(_key, _value));
  }
}