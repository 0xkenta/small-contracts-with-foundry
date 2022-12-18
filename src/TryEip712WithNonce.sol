pragma solidity 0.8.13;

import './Eip712WithNonce.sol';

contract TryEip712WithNonce is Eip712WithNonce {
    
    constructor(
        string memory _name,
        string memory _version,
        address _admin
    ) Eip712WithNonce(_name, _version, _admin) {}

    function usePaymentId(address _address, uint256 _tokenId, string calldata _paymentId, bytes memory _signature) external returns (bool) {
        require(!usedPaymentId[_paymentId], "PAYMENT ID HAS BEEN ALREADY USED");

        bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
           PAYMENT_REQUEST_TYPEHASH,
           _address,
           _tokenId,
           keccak256(bytes(_paymentId)
        ))));

        address signer = ECDSA.recover(digest, _signature);
        require(signer == admin, "INVALID SIGNATURE");

        usedPaymentId[_paymentId] = true;

        return true;
    }
}