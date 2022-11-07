pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./interfaces/ITryEip165.sol";

contract TryEip165 is ERC165 {
    uint256 number;
    function setNumber(uint256 _newNr) external {
        number = _newNr;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165) returns (bool) {
        return
            _interfaceId == type(ITryEip165).interfaceId ||
            super.supportsInterface(_interfaceId);
    }
}