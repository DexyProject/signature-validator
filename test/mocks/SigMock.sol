pragma solidity ^0.4.23;

import "./../../contracts/SignatureValidator.sol";

contract SigMock {

    function isValidSignature(bytes32 hash, address signer, bytes signature) external pure returns (bool) {
        return SignatureValidator.isValidSignature(hash, signer, signature);
    }

    function recover(bytes32 hash, bytes signature) external pure returns (address) {
        return SignatureValidator.recover(hash, signature);
    }
}
