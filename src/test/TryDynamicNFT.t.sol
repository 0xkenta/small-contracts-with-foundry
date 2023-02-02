pragma solidity 0.8.13;

import '../TryDynamicNFT.sol';
import "forge-std/Test.sol";

contract TryDynamicNFTTest is Test {
    TryDynamicNFT nft;

    address user1;

    function setUp() public {
        nft = new TryDynamicNFT("test", "TEST");
        user1 = vm.addr(0xA11CE);
    }

    function test_tokenURI() public {
        _checkBalance(0);
        _checkInfo(1, "", "");
        _checkInfo(2, "", "");

        string memory title1 = "First Playlist";
        string memory artist1 = "AS";

        nft.mint(user1, title1, artist1);

        _checkBalance(1);
        _checkInfo(1, title1, artist1);

        _getLog(1);

        string memory title2 = "Second Playlist";
        string memory artist2 = "TS";

        nft.mint(user1, title2, artist2);

        _checkBalance(2);
        _checkInfo(2, title2, artist2);

        _getLog(2);
    }

    function _checkBalance(uint256 _expectedAmount) private {
        assertEq(nft.balanceOf(user1), _expectedAmount);
    }

    function _checkInfo(
        uint256 _tokenId,
        string memory _expectedTitle,
        string memory _expectedArtist
    ) private {
        (string memory _title, string memory _artist, ) = nft.getInfo(_tokenId);
        assertEq(_title, _expectedTitle);
        assertEq(_artist, _expectedArtist);
    }

    function _getLog(uint256 _tokenId) private view {
        string memory result = nft.tokenURI(_tokenId);
        console.log(result);
    }
}