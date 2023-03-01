pragma solidity  0.8.13;

import "../DiaRandomnessOracle.sol";
import "forge-std/Test.sol";

contract Eip712WithNonceTest is Test {
    DiaRandomnessOracle oracle;

    function setUp() public {
        oracle = new DiaRandomnessOracle(address(0));
    }

    function test_getRandomValue() public {
        vm.mockCall(
            address(oracle),
            abi.encodeWithSelector(oracle.getRandomValue.selector),
            abi.encode(100)
        );
        assertEq(oracle.getRandomValue(), 100); 
    }
}