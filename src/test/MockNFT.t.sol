pragma solidity 0.8.13;

import "../mock/MockNFT.sol";
import "forge-std/Test.sol";

contract MockNFTTest is Test {
    MockNFT nftContract;
    address user1;

    function setUp() public {
        user1 = vm.addr(0xA11CE);
        nftContract = new MockNFT("test", "TEST");
    }

    function test_mint() public {
        assertEq(nftContract.balanceOf(user1), 0);

        uint256 tokenId1 = nftContract.mint(user1);

        assertEq(nftContract.balanceOf(user1), 1);
        assertEq(tokenId1, 1);

        uint256 tokenId2 = nftContract.mint(user1);

        assertEq(nftContract.balanceOf(user1), 2);
        assertEq(tokenId2, 2);
    }
}