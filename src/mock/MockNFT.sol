pragma solidity 0.8.13;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';

contract MockNFT is ERC721 {
    uint256 private nextId = 1;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    function mint(address _to) external returns (uint256) {
        uint256 tokenId = nextId;

        _mint(_to, tokenId);

        nextId++;

        return tokenId;
    }

    function safeMint(address _to) external returns (uint256) {
        uint256 tokenId = nextId;

        _safeMint(_to, tokenId);

        nextId++;

        return tokenId;
    }
}