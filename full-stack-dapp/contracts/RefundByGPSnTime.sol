// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract RefundByGPSnTime {

    // creator of the smart contract
    address payable public creator;             // employer or owner of the smart contract
    address payable public driver;
    address public device;
    uint total_fund_locked = 0.00005 ether;
    uint reward = 0.00002 ether;

    // set of state of the divice
    enum DeviceState {Created, InTransit, Completed, OutOfCompliance}


    // Proprities of Device. Struct stores information about a Device
    struct Device {
        uint latitude;                  //current latitude of the device
        uint longitude;                 //current longitude of the device
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
    mapping(address => Device) public devices;     //************************* */

    // Track which address send ether and how much ether they send
    mapping(address => uint) balances;             //************************ */

    // Event emitted when the compliance state of a device is updated
    event DeviceComplianceUpdated(address indexed device, DeviceState newState);

    // Modifier to ensure that only the createor can execute certain functions
    modifier onlyCreator() {
        require(msg.sender == creator, "Not authorized");
        _;
    }

    modifier onlyDriver() {
        require(msg.sender == driver, "Not authorized");
        _;
    }

    //constructor to set the creator as the deployer of the contract 
    constructor()  {
        creator = payable(msg.sender);
        //device = _device;
        //driver = _driver;
    }

    // Function for the creator to add a new device with specific parameters
    function addDevice(address _device, uint _latitude, uint _longitude, uint _distance) external onlyCreator {
        require(devices[_device].timestamp ==0, "Device already added");

        devices[_device] = Device({
            latitude: _latitude,
            longitude: _longitude,
            distance: _distance,
            timestamp : block.timestamp,
            state: DeviceState.InTransit
        });
    }

    // Function for a device to update its location
    function updateDeviceLocation(address _device, uint _latitude, uint _longitude, uint _distance) external {
        require(devices[_device].timestamp != 0, "Device not registered");

        Device storage devicee = devices[_device];
        
        // Update the device's location and timestamp
        devicee.latitude = _latitude;
        devicee.longitude = _longitude;
        devicee.distance = _distance;
        devicee.timestamp = block.timestamp;

        // if device has completed state
        if (devicee.state == DeviceState.Completed) {
            // driverr.rating = 1;
            // transfer salary from smart contract to Driver

            _transferEtherToDriver(driver);

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
        creator.transfer(_reward);           
    }

    function returnRewardToCreator() external payable {
        if (msg.value < total_fund_locked) {
            revert();  // cancel the transaction
        }
        balances[msg.sender] += msg.value;
    }

    // view balance
    function balanceOf() external view returns (uint) {
        return address(this).balance;
    }



}

