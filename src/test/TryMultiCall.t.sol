// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../TryMultiCall.sol";

contract TryMultiCallTest is DSTest {
    TryMultiCall tryMultiCall;

    function setUp() public {
        
        tryMultiCall = new TryMultiCall();
    }

    function test_setName() public {
        assertEq(tryMultiCall.name(), "");
        string memory newName = "Andi";
        tryMultiCall.setName(newName);
        assertEq(tryMultiCall.name(), newName);
    }

    function test_setCountry() public {
        assertEq(tryMultiCall.country(), "");
        string memory newCountry = "Deutschland";
        tryMultiCall.setCountry(newCountry);
        assertEq(tryMultiCall.country(), newCountry);
    }

    function test_setAge() public {
        assertEq(tryMultiCall.age(), 0);
        uint256 newAge = 42;
        tryMultiCall.setAge(newAge);
        assertEq(tryMultiCall.age(), newAge);
    }

    function test_multicall() public {
        assertEq(tryMultiCall.name(), "");
        assertEq(tryMultiCall.country(), "");
        assertEq(tryMultiCall.age(), 0);

        string memory newName = "Andi";
        string memory newCountry = "Deutschland";
        uint256 newAge = 42;

        bytes[] memory data = new bytes[](3);

        bytes memory dataForSetName = abi.encodeWithSignature("setName(string)", newName);
        bytes memory dataForSetCountry = abi.encodeWithSignature("setCountry(string)", newCountry);
        bytes memory dataForSetAge = abi.encodeWithSignature("setAge(uint256)", newAge);

        data[0] = dataForSetName;
        data[1] = dataForSetCountry;
        data[2] = dataForSetAge;
        
        tryMultiCall.multicall(data);

        assertEq(tryMultiCall.name(), newName);
        assertEq(tryMultiCall.country(), newCountry);
        assertEq(tryMultiCall.age(), newAge);
    }
}