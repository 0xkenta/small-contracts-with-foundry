// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../TryErc721a.sol";

contract TryErc721aTest is Test {
    TryErc721a erc721a;
    address user1;
    address user2;

    uint256 amout1 = 22712;
    uint256 amount2 = 7;

    uint256[] burnedTokenIds = [100, 101, 102, 103, 104, 105];

    uint256[] result1;

    function setUp() public {
        erc721a = new TryErc721a();

        user1 = vm.addr(123456);
        user2 = vm.addr(56789);

        erc721a.mint(user1, amout1);
        erc721a.mint(user2, amount2);
    }

    function test_tokensOfOwner() public {
        assertEq(erc721a.balanceOf(user1), amout1);
        assertEq(erc721a.balanceOf(user2), amount2);

        result1 = erc721a.tokensOfOwner(user2);
        assertEq(result1.length, amount2);
    }

    function test_tokensOfOwner2() public {
        assertEq(erc721a.balanceOf(user1), amout1);
        assertEq(erc721a.balanceOf(user2), amount2);

        vm.prank(user1);
        erc721a.burn(user1, burnedTokenIds);

        assertEq(erc721a.balanceOf(user1), amout1 - burnedTokenIds.length);
        assertEq(erc721a.balanceOf(user2), amount2);

        uint256[] memory ids = erc721a.tokensOfOwner(user2);
        for (uint256 i; i < result1.length;) {
            assertEq(result1[i], ids[i]);
            unchecked {
                ++i;
            }
        }

        uint256[] memory tokensOfOwnerIn = erc721a.tokensOfOwnerIn(user2, 0, type(uint256).max);
        console.log(tokensOfOwnerIn.length);
        for (uint256 i; i < tokensOfOwnerIn.length;) {
            console.log(tokensOfOwnerIn[i]);
            unchecked {
                ++i;
            }
        }
    } 
}