pragma solidity ^0.8.20;

import {TryBurnableNft} from "../TryBurnableNft.sol";
import "forge-std/Test.sol";

error ERC721NonexistentToken(uint256 tokenId);

contract TestBurnableNft is Test {
    TryBurnableNft public burnableNft;

    uint256 tokenId = 1;

    address internal user1;
    address internal user2;
    address internal constant emptyAddress = address(0);

    function setUp() public {
        burnableNft = new TryBurnableNft("test", "TEST");

        uint256 user1PrivateKey = 0xA11CE;
        uint256 user2PrivateKey = 0xA11CD;

        user1 = vm.addr(user1PrivateKey);
        user2 = vm.addr(user2PrivateKey);
    }

    function test_mint() public {
        _checkBalance(user1, 0);

        _mint(user1);
        _checkTokenOwner(user1);
        _checkBalance(user1, 1);
    }

    function test_burn() public {
        _checkBalance(user1, 0);

        _mint(user1);
        _checkTokenOwner(user1);
        _checkBalance(user1, 1);

        _burn();
        _checkBalance(user1, 0);

        vm.expectRevert("ERC721: invalid token ID");
        burnableNft.ownerOf(tokenId);
    }

    function test_burn_mint() public {
        _checkBalance(user1, 0);
        _checkBalance(user2, 0);

        _mint(user1);

        _checkTokenOwner(user1);
        _checkBalance(user1, 1);
        _checkBalance(user2, 0);

        _burn();
        _checkBalance(user1, 0);
        _checkBalance(user2, 0);

        _mint(user2);

        _checkBalance(user1, 0);
        _checkBalance(user2, 1);
        _checkTokenOwner(user2);
    }

    function _mint(address _user) internal {
        burnableNft.mint(_user, tokenId);
    }

    function _burn() internal {
        burnableNft.burn(tokenId);
    }

    function _checkTokenOwner(address _owner) internal {
        address ownerOfToken1 = burnableNft.ownerOf(tokenId);
        assertEq(_owner, ownerOfToken1);
    }

    function _checkBalance(address _user, uint256 _amount) internal {
        uint256 balance = burnableNft.balanceOf(_user);
        assertEq(balance, _amount);
    }
}
