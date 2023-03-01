pragma solidity  0.8.13;

interface IDIARandomOracle {
    function getLastRound() external view returns(uint256);
    function getRandomValueFromRound(uint256 _round) external view returns (string memory);
}

contract DiaRandomnessOracle {
    address diaRandomOracle;

    constructor(address _diaRandomOracle) {
        diaRandomOracle = _diaRandomOracle;
    }
    function getRandomValue() external view returns (uint256) {
        uint256 lastRound = IDIARandomOracle(diaRandomOracle).getLastRound();
        string memory rand = IDIARandomOracle(diaRandomOracle).getRandomValueFromRound(lastRound);
        return uint256(keccak256(abi.encodePacked(rand)));
    }
}