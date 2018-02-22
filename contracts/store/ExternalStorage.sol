pragma solidity 0.4.19;

/// @title The primary persistent storage for Rocket Pool
/// @author David Rugendyke
contract ExternalStorage {

    // ███████╗████████╗ ██████╗ ██████╗  █████╗  ██████╗ ███████╗    ███████╗██╗███████╗██╗     ██████╗ ███████╗
    // ██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝    ██╔════╝██║██╔════╝██║     ██╔══██╗██╔════╝
    // ███████╗   ██║   ██║   ██║██████╔╝███████║██║  ███╗█████╗      █████╗  ██║█████╗  ██║     ██║  ██║███████╗
    // ╚════██║   ██║   ██║   ██║██╔══██╗██╔══██║██║   ██║██╔══╝      ██╔══╝  ██║██╔══╝  ██║     ██║  ██║╚════██║
    // ███████║   ██║   ╚██████╔╝██║  ██║██║  ██║╚██████╔╝███████╗    ██║     ██║███████╗███████╗██████╔╝███████║
    // ╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═╝╚══════╝╚══════╝╚═════╝ ╚══════╝                                                                                                              
    mapping(bytes32 => uint256)    private uIntStorage;
    mapping(bytes32 => string)     private stringStorage;
    mapping(bytes32 => address)    private addressStorage;
    mapping(bytes32 => bytes)      private bytesStorage;
    mapping(bytes32 => bool)       private boolStorage;
    mapping(bytes32 => int256)     private intStorage;


    // ███╗   ███╗ ██████╗ ██████╗ ██╗███████╗██╗███████╗██████╗ ███████╗
    // ████╗ ████║██╔═══██╗██╔══██╗██║██╔════╝██║██╔════╝██╔══██╗██╔════╝
    // ██╔████╔██║██║   ██║██║  ██║██║█████╗  ██║█████╗  ██████╔╝███████╗
    // ██║╚██╔╝██║██║   ██║██║  ██║██║██╔══╝  ██║██╔══╝  ██╔══██╗╚════██║
    // ██║ ╚═╝ ██║╚██████╔╝██████╔╝██║██║     ██║███████╗██║  ██║███████║
    // ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝

    /// @dev Only allow access from the latest version 
    /// of a contract in the Rocket Pool network after deployment
    modifier restictAccessToLatestContract() {
        // The owner and other contracts are only allowed to set the storage upon deployment to register the initial contracts/settings, afterwards their direct access is disabled
        if (getBool("contract.storage.initialised") == true) {
            // Make sure the access is permitted to only contracts in our Dapp
            require(getAddress(keccak256("contract.address", msg.sender)) != address(0x0));
        }
        _;
    }

    /// @dev constructor
    function ExternalStorage() public {
        // Set the main owner upon deployment
        setBool(keccak256("access.role", "owner", msg.sender), true);
    }

    //  ██████╗ ███████╗████████╗████████╗███████╗██████╗ ███████╗
    // ██╔════╝ ██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
    // ██║  ███╗█████╗     ██║      ██║   █████╗  ██████╔╝███████╗
    // ██║   ██║██╔══╝     ██║      ██║   ██╔══╝  ██╔══██╗╚════██║
    // ╚██████╔╝███████╗   ██║      ██║   ███████╗██║  ██║███████║
    //  ╚═════╝ ╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
                                                            
    /// @param _key The key for the record
    function getAddress(bytes32 _key) external view returns (address) {
        return addressStorage[_key];
    }

    /// @param _key The key for the record
    function getUint(bytes32 _key) external view returns (uint) {
        return uIntStorage[_key];
    }

    /// @param _key The key for the record
    function getString(bytes32 _key) external view returns (string) {
        return stringStorage[_key];
    }

    /// @param _key The key for the record
    function getBytes(bytes32 _key) external view returns (bytes) {
        return bytesStorage[_key];
    }

    /// @param _key The key for the record
    function getBool(bytes32 _key) external view returns (bool) {
        return boolStorage[_key];
    }

    /// @param _key The key for the record
    function getInt(bytes32 _key) external view returns (int) {
        return intStorage[_key];
    }

    /// @param _key The key for the record
    function getAddress(string _key) external view returns (address) {
        return addressStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function getUint(string _key) external view returns (uint) {
        return uIntStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function getString(string _key) external view returns (string) {
        return stringStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function getBytes(string _key) external view returns (bytes) {
        return bytesStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function getBool(string _key) external view returns (bool) {
        return boolStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function getInt(string _key) external view returns (int) {
        return intStorage[keccak256(_key)];
    }

    // ███████╗███████╗████████╗████████╗███████╗██████╗ ███████╗
    // ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
    // ███████╗█████╗     ██║      ██║   █████╗  ██████╔╝███████╗
    // ╚════██║██╔══╝     ██║      ██║   ██╔══╝  ██╔══██╗╚════██║
    // ███████║███████╗   ██║      ██║   ███████╗██║  ██║███████║
    // ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
    /// @param _key The key for the record
    function setAddress(bytes32 _key, address _value) restictAccessToLatestContract external {
        addressStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setUint(bytes32 _key, uint _value) restictAccessToLatestContract external {
        uIntStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setString(bytes32 _key, string _value) restictAccessToLatestContract external {
        stringStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setBytes(bytes32 _key, bytes _value) restictAccessToLatestContract external {
        bytesStorage[_key] = _value;
    }
    
    /// @param _key The key for the record
    function setBool(bytes32 _key, bool _value) restictAccessToLatestContract external {
        boolStorage[_key] = _value;
    }
    
    /// @param _key The key for the record
    function setInt(bytes32 _key, int _value) restictAccessToLatestContract external {
        intStorage[_key] = _value;
    }

    /// @param _key The key for the record
    function setAddress(string _key, address _value) restictAccessToLatestContract external {
        addressStorage[keccak256(_key)] = _value;
    }

    /// @param _key The key for the record
    function setUint(string _key, uint _value) restictAccessToLatestContract external {
        uIntStorage[keccak256(_key)] = _value;
    }

    /// @param _key The key for the record
    function setString(string _key, string _value) restictAccessToLatestContract external {
        stringStorage[keccak256(_key)] = _value;
    }

    /// @param _key The key for the record
    function setBytes(string _key, bytes _value) restictAccessToLatestContract external {
        bytesStorage[keccak256(_key)] = _value;
    }
    
    /// @param _key The key for the record
    function setBool(string _key, bool _value) restictAccessToLatestContract external {
        boolStorage[keccak256(_key)] = _value;
    }
    
    /// @param _key The key for the record
    function setInt(string _key, int _value) restictAccessToLatestContract external {
        intStorage[keccak256(_key)] = _value;
    }

    // ██████╗ ███████╗███╗   ███╗ ██████╗ ██╗   ██╗███████╗
    // ██╔══██╗██╔════╝████╗ ████║██╔═══██╗██║   ██║██╔════╝
    // ██████╔╝█████╗  ██╔████╔██║██║   ██║██║   ██║█████╗  
    // ██╔══██╗██╔══╝  ██║╚██╔╝██║██║   ██║╚██╗ ██╔╝██╔══╝  
    // ██║  ██║███████╗██║ ╚═╝ ██║╚██████╔╝ ╚████╔╝ ███████╗
    // ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝
                                                             
    /// @param _key The key for the record
    function deleteAddress(bytes32 _key) restictAccessToLatestContract external {
        delete addressStorage[_key];
    }

    /// @param _key The key for the record
    function deleteUint(bytes32 _key) restictAccessToLatestContract external {
        delete uIntStorage[_key];
    }

    /// @param _key The key for the record
    function deleteString(bytes32 _key) restictAccessToLatestContract external {
        delete stringStorage[_key];
    }

    /// @param _key The key for the record
    function deleteBytes(bytes32 _key) restictAccessToLatestContract external {
        delete bytesStorage[_key];
    }
    
    /// @param _key The key for the record
    function deleteBool(bytes32 _key) restictAccessToLatestContract external {
        delete boolStorage[_key];
    }
    
    /// @param _key The key for the record
    function deleteInt(bytes32 _key) restictAccessToLatestContract external {
        delete intStorage[_key];
    }
                                                             
    /// @param _key The key for the record
    function deleteAddress(string _key) restictAccessToLatestContract external {
        delete addressStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function deleteUint(string _key) restictAccessToLatestContract external {
        delete uIntStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function deleteString(string _key) restictAccessToLatestContract external {
        delete stringStorage[keccak256(_key)];
    }

    /// @param _key The key for the record
    function deleteBytes(string _key) restictAccessToLatestContract external {
        delete bytesStorage[keccak256(_key)];
    }
    
    /// @param _key The key for the record
    function deleteBool(string _key) restictAccessToLatestContract external {
        delete boolStorage[keccak256(_key)];
    }
    
    /// @param _key The key for the record
    function deleteInt(string _key) restictAccessToLatestContract external {
        delete intStorage[keccak256(_key)];
    }
}
