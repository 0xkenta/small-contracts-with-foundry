pragma solidity  0.8.13;

import "../TryEip712WithNonce.sol";
import "../Eip712WithNonce.sol";
import "forge-std/Test.sol";

contract Eip712WithNonceTest is Test {
    TryEip712WithNonce eip712;

    uint256 internal adminPrivateKey;
    uint256 internal user1PrivateKey;

    address internal admin;
    address internal user1;

    bytes32 private TYPE_HASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );
    bytes32 DOMAIN_SEPARATER;
    bytes32 constant PAYMENT_REQUEST_TYPEHASH = keccak256(
        "PaymentRequest(address _address, uint256 _tokenId, string calldate _paymentId)"
    );

    function setUp() public {
        adminPrivateKey = 0xA11CE;
        user1PrivateKey = 0xB0B;

        admin = vm.addr(adminPrivateKey);
        user1 = vm.addr(user1PrivateKey);

        string memory name = "test";
        string memory version = "1.0.0";

        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));

        eip712 = new TryEip712WithNonce(name, version, admin);
        DOMAIN_SEPARATER = keccak256(abi.encode(TYPE_HASH, hashedName, hashedVersion, block.chainid, address(eip712)));
    }

    function test_usePaymentId() public {
        bool result = _usePaymentId();
        assert(result);
    }

    function test_usePaymentId_with_used_paymentId() public {
        _usePaymentId();
        vm.expectRevert("PAYMENT ID HAS BEEN ALREADY USED");
        _usePaymentId();
    }

    function _usePaymentId() internal returns (bool) {
        bytes32 digest = ECDSA.toTypedDataHash(DOMAIN_SEPARATER, (keccak256(abi.encode(
           PAYMENT_REQUEST_TYPEHASH,
           user1,
           1,
           keccak256(bytes("12345"))
        ))));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(adminPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);
        bool result = eip712.usePaymentId(user1, 1, "12345", signature);

        return result;
    }
}