pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./interfaces/ITryEip165.sol";

contract TryEip165Prove {
    address public testContract;
    bytes4 private constant INTERFACE_ID_TRYEIP165 =
        type(ITryEip165).interfaceId;

    constructor(address _testContract) {
        testContract = _testContract;
    }

    function prove() external view returns (bool) {
        return IERC165(testContract).supportsInterface(INTERFACE_ID_TRYEIP165);
    }
}