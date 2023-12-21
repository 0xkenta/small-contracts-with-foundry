pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TryBurnableNft is ERC721, Ownable {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable() {}

    function mint(address _to, uint256 _tokenId) external onlyOwner {
        _safeMint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) external onlyOwner {
        _burn(_tokenId);
    }
}
