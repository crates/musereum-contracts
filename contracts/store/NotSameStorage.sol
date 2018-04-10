pragma solidity ^0.4.18;

interface IExternalStore {
  function setAddress(bytes32 _key, address _value) external returns (bool);
  function setUint(bytes32 _key, uint _value) external returns (bool);
  function setBytes(bytes32 _key, bytes32 _value) external returns (bool);
  function setBool(bytes32 _key, bool _value) external returns (bool);
  function setInt(bytes32 _key, int _value) external returns (bool);
  function setString(bytes32 _key, string _value) external returns (bool);
  function setBuffer(bytes32 _key, bytes _value) external returns (bool);
}

library NotSameStorage {
  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherUint(IExternalStore externalStore, bytes32 _key, uint _value) public {
    require(externalStore.setUint(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherAddress(IExternalStore externalStore, bytes32 _key, address _value) public {
    require(externalStore.setAddress(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBytes(IExternalStore externalStore, bytes32 _key, bytes32 _value) public {
    require(externalStore.setBytes(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBool(IExternalStore externalStore, bytes32 _key, bool _value) public {
    require(externalStore.setBool(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherInt(IExternalStore externalStore, bytes32 _key, int _value) public {
    require(externalStore.setInt(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherString(IExternalStore externalStore, bytes32 _key, string _value) public {
    require(externalStore.setString(_key, _value));
  }

  /// @param _key The key for the record
  /// @param _value to store at providen _key
  /// @return bool is value is changed
  function setAnotherBuffer(IExternalStore externalStore, bytes32 _key, bytes _value) public {
    require(externalStore.setBuffer(_key, _value));
  }
}