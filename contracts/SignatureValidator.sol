pragma solidity ^0.4.18;

library SignatureValidator {

    enum SignatureMode {
        TYPED_SIGN,
        GETH,
        TREZOR
    }

    /// @dev Validates that a hash was signed by a specified signer.
    /// @param hash Hash which was signed.
    /// @param signer Address of the signer.
    /// @param signature ECDSA signature along with the mode (0 = Typed (EIP712), 1 = Geth, 2 = Trezor) {mode}{v}{r}{s}.
    /// @return Returns whether signature is from a specified user.
    function isValidSignature(bytes32 hash, address signer, bytes signature) internal pure returns (bool) {
        return recover(hash, signature) == signer;
    }

    /// @dev Recovers signer from signature.
    /// @param hash Hash which was signed.
    /// @param signature ECDSA signature along with the mode (0 = Typed (EIP712), 1 = Geth, 2 = Trezor) {mode}{v}{r}{s}.
    /// @return Returns Address of the signer.
    function recover(bytes32 hash, bytes signature) internal pure returns (address) {
        require(signature.length == 66);
        SignatureMode mode = SignatureMode(uint8(signature[0]));

        uint8 v = uint8(signature[1]);
        bytes32 r;
        bytes32 s;
        assembly {
            r := mload(add(signature, 34))
            s := mload(add(signature, 66))
        }

        if (mode == SignatureMode.GETH) {
            hash = keccak256("\x19Ethereum Signed Message:\n32", hash);
        } else if (mode == SignatureMode.TREZOR) {
            hash = keccak256("\x19Ethereum Signed Message:\n\x20", hash);
        }

        return ecrecover(hash, v, r, s);
    }
}
