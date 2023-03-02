pragma solidity  0.8.13;

import "forge-std/Test.sol";
import "../TestSlots.sol";

contract TestSlotsTest is Test {
    TestSlots testSlots;

    function setUp() public {
        testSlots = new TestSlots();
    }

    function test_slot() public {
        using stdStorage for StdStorage;

        uint256 slot = stdstore.target(address(testSlots)).sig(number2).find();
        console.log(slot);
    }
}