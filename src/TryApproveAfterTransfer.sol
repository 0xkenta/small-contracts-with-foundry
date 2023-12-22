pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TryApproveAfterTransfer is ERC721, Ownable {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable() {}

    function mint(address _to, uint256 _tokenId) external onlyOwner {
        _safeMint(_to, _tokenId);
    }

    function mintAndApprove(address _to, uint256 _tokenId) external onlyOwner {
        _safeMint(_to, _tokenId);

        /// the latest version has no _afterTokenTransfer, so try to implement here.
        _approve(owner(), _tokenId);
    }

    function disapprove(uint256 _tokenId) external {
        address owner = ownerOf(_tokenId);
        require(msg.sender == owner, "Only owner can call this function");

        _approve(address(0), _tokenId);
    }
}
