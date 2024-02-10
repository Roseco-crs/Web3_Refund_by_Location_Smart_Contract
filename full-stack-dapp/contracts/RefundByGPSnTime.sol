// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract RefundByGPSnTime {

    // creator of the smart contract
    address public creator;             // employer or owner of the smart contract
    address public driver;
    address public device;

    // set of state
    enum StateType {Created, InTransit, Completed, OutOfCompliance}
    

    // enum, here, represent compliance state of the device.
    enum DeviceState{
        InCompliance,
        OutOfCompliance
    }


    // Proprities of Device. Struct stores information about a Device
    struct Device {
        uint latitude;                  //current latitude of the device
        uint longitude;                 //current longitude of the device
        uint distance;                  //Remaing distance to the target destination
        //uint complianceRange;         //allowed compliance range for device
        uint timestamp;                 //Timestamp of the last update from the device 
        DeviceState state;              //Current compliance state of the device
    }

    // Proprities of Driver. Struct stores driver information
    struct Driver {
        address driver_account;
        string driver_name;
    }

    // I should define the relationship between the driver and the device using a mapp

    // adding Devices into a mapping
    mapping(address => Device) public devices; 

    // Track which address send ether and how much ether they send
    mapping(address => uint) balances;

    // Event emitted when the compliance state of a device is updated
    event DeviceComplianceUpdated(address indexed device, DeviceState newState);

    // Modifier to ensure that only the createor can execute certain functions
    modifier onlyCreator() {
        require(msg.sender == creator, "Not authorized");
        _;
    }

    //constructor to set the creator as the deployer of the contract 
    constructor(address _creator, address _device, address _driver) public {
        creator = msg.sender;
        device = _device;
        driver = _driver;
    }

    // Function for the creator to add a new device with specific parameters
    function addDevice(address _device, uint _latitude, uint _longitude, uint _complianceRange) external onlyCreator {
        require(devices[_device].lastUpdateTimestamp ==0, "Device already added");

        devices[_device] = Device({
            latitude: _latitude,
            longitude: _longitude,
            complianceRange: _complianceRange,
            lastUpdateTimestamp: block.timestamp,
            state: DeviceState.InCompliance
        });
    }

    // Function for a device to update its location
    function updateDeviceLocation(address _device, uint _latitude, uint _longitude) external {
        require(devices[_device].lastUpdateTimestamp != 0, "Device not registered");

        Device storage device = devices[_device];

        // Check if the device is within the specified compliance range
        //require(isWithinRange(_latitude, _longitude, device.latitude, device.longitude, device.complianceRange), "Out of compliance");
        
        // Update the device's location and timestamp
        device.latitude = _latitude;
        device.longitude = _longitude;
        device.lastUpdateTimestamp = block.timestamp;

        // If the device was previously out of compliance, update its state and emit an event
        if (device.state == DeviceState.OutOfCompliance) {
            device.state = DeviceState.InCompliance;
            emit DeviceComplianceUpdated(_device, DeviceState.InCompliance);
        }
    }


    /*
    // Internal function to check if two sets of GPS coordinates are within a specified range
    function isWithinRange(
        uint _latDevice,
        uint _lonDevice,
        uint _latTarget,
        uint _lonTarget,
        uint _range
    ) internal pure returns (bool) {
        // Implement the GPS range check logic, similar to the previous example
        // ...
        return true;   // Placeholder, replace with actual logic
    }
    */


    function reward() external payable {
        if (msg.value < 1000) {
            revert();  // cancel the transaction
        }
        blances[msg.sender] + = msg.value;
    }

    function balanceOf() external view returns (uint) {
        return address(this).balance;
    }



}

