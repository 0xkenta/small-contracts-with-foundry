pragma solidity 0.8.13;

interface ITryEip165 {
    function setNumber(uint256 _newNr) external;
    function getNumber() external view;
}