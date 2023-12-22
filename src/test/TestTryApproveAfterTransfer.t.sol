pragma solidity ^0.8.20;

import {TryApproveAfterTransfer} from "../TryApproveAfterTransfer.sol";
import "forge-std/Test.sol";

contract TestBurnableNft is Test {
    TryApproveAfterTransfer public nft;

    uint256 tokenId = 1;

    address internal owner;
    address internal user1;
    address internal user2;
    address internal constant emptyAddress = address(0);

    function setUp() public {
        nft = new TryApproveAfterTransfer("test", "TEST");

        uint256 user1PrivateKey = 0xA11CD;
        uint256 user2PrivateKey = 0xA11CC;

        owner = nft.owner();
        user1 = vm.addr(user1PrivateKey);
        user2 = vm.addr(user2PrivateKey);
    }

    function test_tranferAfterMintWithoutApprove() public {
        _mint();

        vm.prank(owner);
        vm.expectRevert("ERC721: caller is not token owner or approved");
        nft.safeTransferFrom(user1, user2, tokenId);
    }

    function test_transferAfterMintAndApprove() public {
        _mintAndApprove();

        address tokenOwnerBefore = nft.ownerOf(tokenId);
        assertEq(tokenOwnerBefore, user1);

        vm.prank(owner);
        nft.safeTransferFrom(user1, user2, tokenId);

        address tokenOwnerAfter = nft.ownerOf(tokenId);
        assertEq(tokenOwnerAfter, user2);
    }

    function test_disapprove() public {
        _mintAndApprove();

        address tokenOwnerBefore = nft.ownerOf(tokenId);
        assertEq(tokenOwnerBefore, user1);

        vm.prank(user1);
        nft.disapprove(tokenId);

        vm.prank(owner);
        vm.expectRevert("ERC721: caller is not token owner or approved");
        nft.safeTransferFrom(user1, user2, tokenId);
    }

    function _mint() internal {
        nft.mint(user1, tokenId);
    }

    function _mintAndApprove() internal {
        nft.mintAndApprove(user1, tokenId);
    }
}
