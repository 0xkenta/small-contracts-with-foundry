pragma solidity 0.8.13;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Eip712WithNonce {
    bytes32 private HASHED_NAME;
    bytes32 private HASHED_VERSION;

    bytes32 constant TYPE_HASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );
    bytes32 constant PAYMENT_REQUEST_TYPEHASH = keccak256(
        "PaymentRequest(address _address, uint256 _tokenId, string calldate _paymentId)"
    );

    address immutable admin;

    mapping (string => bool) internal usedPaymentId;

    constructor(string memory name, string memory version, address _admin) {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        
        HASHED_NAME = hashedName;
        HASHED_VERSION = hashedVersion;

        admin = _admin;
    }

    function _domainSeparatorV4() internal view returns (bytes32) {
        return _buildDomainSeparator(TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
    }

    function _buildDomainSeparator(
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(TYPE_HASH, nameHash, versionHash, block.chainid, address(this)));
    }

    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    function _EIP712NameHash() internal virtual view returns (bytes32) {
        return HASHED_NAME;
    }

    function _EIP712VersionHash() internal virtual view returns (bytes32) {
        return HASHED_VERSION;
    }
}