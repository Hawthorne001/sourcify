{
  "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v5.0.0) (utils/cryptography/MessageHashUtils.sol)\n\npragma solidity ^0.8.20;\n\nimport {Strings} from \"../Strings.sol\";\n\n/**\n * @dev Signature message hash utilities for producing digests to be consumed by {ECDSA} recovery or signing.\n *\n * The library provides methods for generating a hash of a message that conforms to the\n * https://eips.ethereum.org/EIPS/eip-191[EIP 191] and https://eips.ethereum.org/EIPS/eip-712[EIP 712]\n * specifications.\n */\nlibrary MessageHashUtils {\n    /**\n     * @dev Returns the keccak256 digest of an EIP-191 signed data with version\n     * `0x45` (`personal_sign` messages).\n     *\n     * The digest is calculated by prefixing a bytes32 `messageHash` with\n     * `\"\\x19Ethereum Signed Message:\\n32\"` and hashing the result. It corresponds with the\n     * hash signed when using the https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`] JSON-RPC method.\n     *\n     * NOTE: The `messageHash` parameter is intended to be the result of hashing a raw message with\n     * keccak256, although any bytes32 value can be safely used because the final digest will\n     * be re-hashed.\n     *\n     * See {ECDSA-recover}.\n     */\n    function toEthSignedMessageHash(bytes32 messageHash) internal pure returns (bytes32 digest) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            mstore(0x00, \"\\x19Ethereum Signed Message:\\n32\") // 32 is the bytes-length of messageHash\n            mstore(0x1c, messageHash) // 0x1c (28) is the length of the prefix\n            digest := keccak256(0x00, 0x3c) // 0x3c is the length of the prefix (0x1c) + messageHash (0x20)\n        }\n    }\n\n    /**\n     * @dev Returns the keccak256 digest of an EIP-191 signed data with version\n     * `0x45` (`personal_sign` messages).\n     *\n     * The digest is calculated by prefixing an arbitrary `message` with\n     * `\"\\x19Ethereum Signed Message:\\n\" + len(message)` and hashing the result. It corresponds with the\n     * hash signed when using the https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`] JSON-RPC method.\n     *\n     * See {ECDSA-recover}.\n     */\n    function toEthSignedMessageHash(bytes memory message) internal pure returns (bytes32) {\n        return\n            keccak256(bytes.concat(\"\\x19Ethereum Signed Message:\\n\", bytes(Strings.toString(message.length)), message));\n    }\n\n    /**\n     * @dev Returns the keccak256 digest of an EIP-191 signed data with version\n     * `0x00` (data with intended validator).\n     *\n     * The digest is calculated by prefixing an arbitrary `data` with `\"\\x19\\x00\"` and the intended\n     * `validator` address. Then hashing the result.\n     *\n     * See {ECDSA-recover}.\n     */\n    function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {\n        return keccak256(abi.encodePacked(hex\"19_00\", validator, data));\n    }\n\n    /**\n     * @dev Returns the keccak256 digest of an EIP-712 typed data (EIP-191 version `0x01`).\n     *\n     * The digest is calculated from a `domainSeparator` and a `structHash`, by prefixing them with\n     * `\\x19\\x01` and hashing the result. It corresponds to the hash signed by the\n     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`] JSON-RPC method as part of EIP-712.\n     *\n     * See {ECDSA-recover}.\n     */\n    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 digest) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            let ptr := mload(0x40)\n            mstore(ptr, hex\"19_01\")\n            mstore(add(ptr, 0x02), domainSeparator)\n            mstore(add(ptr, 0x22), structHash)\n            digest := keccak256(ptr, 0x42)\n        }\n    }\n}\n"
}