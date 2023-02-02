pragma solidity 0.8.13;

import "../mock/MockNFT.sol";
import "../OverrideOnERC721Received.sol";
import "forge-std/Test.sol";

contract OverrideOnERC721ReceivedTest is Test {
    OverrideOnERC721Received receiver;
    MockNFT nftContract;

    address user1;

    function setUp() public {
        receiver = new OverrideOnERC721Received();
        nftContract = new MockNFT("test", "TEST");

        user1 = vm.addr(0xA11CE);
    }

    function test_does_not_add_tokenId_to_tokenIds_with_mint() public {
        _checkBalance(address(receiver), 0);
        _tokenIdsLengthIsZero();

        uint256 tokenId1 = nftContract.mint(address(receiver)); 
        assertEq(tokenId1, 1);
        _checkBalance(address(receiver), 1);
        _tokenIdsLengthIsZero();

        uint256 tokenId2 = nftContract.mint(address(receiver));
        
        assertEq(tokenId2, 2);
        _checkBalance(address(receiver), 2);
        _tokenIdsLengthIsZero();
    }

    function test_add_tokenId_to_tokenIds_with_safeMint() public {
        _checkBalance(address(receiver), 0);
        _tokenIdsLengthIsZero();

        uint256 tokenId1 = nftContract.safeMint(address(receiver));
         
        assertEq(tokenId1, 1);
        _checkBalance(address(receiver), 1);
        uint256[] memory tokenIdsAfterFirstMint = receiver.getTokenIds();
        assertEq(tokenIdsAfterFirstMint.length, 1);
        assertEq(tokenIdsAfterFirstMint[0], tokenId1);

        uint256 tokenId2 = nftContract.safeMint(address(receiver));
         
        _checkBalance(address(receiver), 2);
        uint256[] memory tokenIdsAfterSecondMint = receiver.getTokenIds();
        assertEq(tokenIdsAfterSecondMint.length, 2);
        assertEq(tokenIdsAfterSecondMint[0], tokenId1);
        assertEq(tokenIdsAfterSecondMint[1], tokenId2);
    }

    function test_does_not_add_tokenId_to_tokenIds_with_transferFrom() public {
        _mintNFTsToUser();
        _checkBalance(address(receiver), 0);

        vm.startPrank(user1);
        nftContract.transferFrom(user1, address(receiver), 1);

        _checkBalance(user1, 1);
        _checkBalance(address(receiver), 1);
        _tokenIdsLengthIsZero();

        nftContract.transferFrom(user1, address(receiver), 2);
        vm.stopPrank();

        _checkBalance(user1, 0);
        _checkBalance(address(receiver), 2);
        _tokenIdsLengthIsZero();
    }

    function test_add_tokenId_to_tokenIds_with_safeTransferFrom() public {
        _mintNFTsToUser();
        _checkBalance(address(receiver), 0);

        uint256 firstTransferTokenId = 1;
        uint256 secondTransferTokenId = 2;

        vm.startPrank(user1);
        nftContract.safeTransferFrom(user1, address(receiver), firstTransferTokenId);

        _checkBalance(user1, 1);
        _checkBalance(address(receiver), 1);
        uint256[] memory tokenIdsAfterFirstTransfer = receiver.getTokenIds();
        assertEq(tokenIdsAfterFirstTransfer.length, 1);
        assertEq(tokenIdsAfterFirstTransfer[0], firstTransferTokenId);

        nftContract.safeTransferFrom(user1, address(receiver), secondTransferTokenId);
        vm.stopPrank();

        _checkBalance(user1, 0);
        _checkBalance(address(receiver), 2);
        uint256[] memory tokenIdsAfterSecondTransfer = receiver.getTokenIds();
        assertEq(tokenIdsAfterSecondTransfer.length, 2);
        assertEq(tokenIdsAfterSecondTransfer[1], secondTransferTokenId);
    }

    function _checkBalance(address _account, uint256 _expectedBalance) private {
        assertEq(nftContract.balanceOf(_account), _expectedBalance);
    }

    function _tokenIdsLengthIsZero() private {
        uint256[] memory tokenIds = receiver.getTokenIds();
        assertEq(tokenIds.length, 0);
    }

    function _mintNFTsToUser() private {
        for (uint8 i; i < 2;) {
            nftContract.mint(user1);
            {++i;}
        }
        _checkBalance(user1, 2);
    }
}