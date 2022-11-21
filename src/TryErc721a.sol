pragma solidity 0.8.13;

import "@ERC721A/contracts/extensions/ERC721AQueryable.sol";

contract TryErc721a is ERC721AQueryable {
    constructor() ERC721A("test", "TEST") {}

    function mint(address _to, uint256 _quantity) external {
        _safeMint(_to, _quantity);
    }

    function burn(address _user, uint256[] calldata _tokenIds) external {
        for (uint256 i; i < _tokenIds.length; ) {
            require(_user == ownerOf(_tokenIds[i]), "NO PERMISSION FOR THIS TOKEN");
            _burn(_tokenIds[i]);

            unchecked {
                ++i;
            }
        }
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }
}