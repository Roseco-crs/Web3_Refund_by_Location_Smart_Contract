// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract RefundByGPSnTime {

    // creator of the smart contract
    address public creatorAccount = msg.sender;             // employer or owner of the smart contract
    address public driverAccount;
    address public deviceAccount;
    uint total_fund_locked = 0.00005 ether;
    uint reward = 0.00002 ether;

    // set of state of the divice
    enum DeviceState {Created, InTransit, Completed, OutOfCompliance}


    // Proprities of Device. Struct stores information about a Device
    struct DeviceCheckPoint {
        int latitude;                  //current latitude of the device
        int longitude;                 //current longitude of the device
        uint distance;                  //Remaing distance to the target destination
        uint timestamp;                 //Timestamp of the last update from the device 
        DeviceState state;              //Current compliance state of the device
    }

    // Proprities of Driver. Struct stores driver information
    struct Driver {
        address driver;
        string name;
        uint rating;
    }

    //driverr = Driver (driver, name, rating);

    // I should define the relationship between the driver and the device using a mapp

    // adding Devices into a mapping
    mapping(address => DeviceCheckPoint) public deviceReadings;     //************************* */

    // Track which address send ether and how much ether they send
    mapping(address => uint) balances;             //************************ */

    // Event emitted when the compliance state of a device is updated
    event DeviceComplianceUpdated(address indexed deviceAccount, DeviceState newState);

    // Modifier to ensure that only the createor can execute certain functions
    modifier onlyCreator() {
        require(msg.sender == creatorAccount, "Not authorized");
        _;
    }

    modifier onlyDriver() {
        require(msg.sender == driverAccount, "Not authorized");
        _;
    }

    /*//constructor to set the creator as the deployer of the contract 
    constructor(address _creatorAccount, address _driverAccount, address _deviceAccount) {
        creatorAccount = _creatorAccount;
        driverAccount = _driverAccount;
        deviceAccount = _deviceAccount;
    }*/


    // Function for the creator to add a new device with specific parameters
    function addDevice(address _deviceAccount, int _latitude, int _longitude, uint _distance) external onlyCreator {
        require(deviceReadings[_deviceAccount].timestamp == 0, "Device already added");

        deviceReadings[_deviceAccount] = DeviceCheckPoint({
            latitude: _latitude,
            longitude: _longitude,
            distance: _distance,
            timestamp : block.timestamp,
            state: DeviceState.Completed
        });
    }

    // Function for a device to update its location
    function updateDeviceLocation(int _latitude, int _longitude, uint _distance, uint _timestamp) external {
        require(msg.sender == deviceAccount, "Not Authorized");
        deviceReadings[msg.sender] = DeviceCheckPoint(
            {latitude:_latitude, 
            longitude:_longitude, 
            distance: _distance, 
            timestamp: _timestamp,
            state: DeviceState.Completed}
            );

        DeviceCheckPoint storage devicee = deviceReadings[deviceAccount];
        /*
        require(deviceReadings[_deviceAccount].timestamp != 0, "Device not registered");

        DeviceCheckPoint storage devicee = deviceReadings[_deviceAccount];
        
        // Update the device's location and timestamp
        devicee.latitude = _latitude;
        devicee.longitude = _longitude;
        devicee.distance = _distance;
        devicee.timestamp = block.timestamp;  */

        // if device has completed state
        if (devicee.state == DeviceState.Completed) {
            // driverr.rating = 1;
            // transfer salary from smart contract to Driver

            _transferEtherToDriver(payable(driverAccount));

        }
        else if (devicee.state == DeviceState.OutOfCompliance) {
            // driverr.rating = 0.5 ;
            // Return the 5000 Wei to smart contract owner
            transferEtherToCreator(reward);

        }        

    }

    // transfer from smart contract to recipient
    function _transferEtherToDriver(address payable _recipient) internal{
        _recipient.transfer(total_fund_locked);           
    }

    // send value from smart contract to the owner/creator
    function transferEtherToCreator(uint _reward) public onlyCreator {
        require((address(this).balance) >= _reward, "Insufficient balance in the contract");      
        payable(creatorAccount).transfer(_reward);           
    }

}

