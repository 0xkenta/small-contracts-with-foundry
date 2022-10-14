pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/Multicall.sol";

contract TryMultiCall is Multicall {
    string public name;
    string public country;
    uint256 public age;

    event NameUpdated();
    event CountryUpdated();
    event AgeUpdated();

    constructor() {}

    function setName(string calldata _name) external {
        name = _name;
        emit NameUpdated();
    }

    function setCountry(string calldata _country) external {
        country = _country;
        emit CountryUpdated();
    }

    function setAge(uint256 _age) external {
        age = _age;
        emit AgeUpdated();
    }
}
