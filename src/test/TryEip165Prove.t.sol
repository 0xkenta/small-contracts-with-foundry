// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "../TryEip165Prove.sol";
import "../TryEip165.sol";

contract TryEipProveTest is DSTest {
    TryEip165Prove public tryEip165Prove;
    TryEip165 public tryEip165;
    function setUp() public {
        tryEip165 = new TryEip165();
        tryEip165Prove = new TryEip165Prove(address(tryEip165));
    }

    function test_prove() public {
        assertTrue(tryEip165Prove.prove());
    }
}