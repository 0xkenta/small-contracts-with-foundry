pragma solidity 0.8.13;

import '@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol';

contract OverrideOnERC721Received is ERC721Holder {
    uint256[] private tokenIds;
    uint256 tokenId;

    function onERC721Received(address, address, uint256 _tokenId, bytes memory) public override returns (bytes4) {
        tokenIds.push(_tokenId);
        return this.onERC721Received.selector;
    }
    
    function getTokenIds() external view returns (uint256[] memory) {
        return tokenIds;
    }
}