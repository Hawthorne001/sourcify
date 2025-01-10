{
  "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v5.0.0) (utils/Create2.sol)\n\npragma solidity ^0.8.20;\n\n/**\n * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.\n * `CREATE2` can be used to compute in advance the address where a smart\n * contract will be deployed, which allows for interesting new mechanisms known\n * as 'counterfactual interactions'.\n *\n * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more\n * information.\n */\nlibrary Create2 {\n    /**\n     * @dev Not enough balance for performing a CREATE2 deploy.\n     */\n    error Create2InsufficientBalance(uint256 balance, uint256 needed);\n\n    /**\n     * @dev There's no code to deploy.\n     */\n    error Create2EmptyBytecode();\n\n    /**\n     * @dev The deployment failed.\n     */\n    error Create2FailedDeployment();\n\n    /**\n     * @dev Deploys a contract using `CREATE2`. The address where the contract\n     * will be deployed can be known in advance via {computeAddress}.\n     *\n     * The bytecode for a contract can be obtained from Solidity with\n     * `type(contractName).creationCode`.\n     *\n     * Requirements:\n     *\n     * - `bytecode` must not be empty.\n     * - `salt` must have not been used for `bytecode` already.\n     * - the factory must have a balance of at least `amount`.\n     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.\n     */\n    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address addr) {\n        if (address(this).balance < amount) {\n            revert Create2InsufficientBalance(address(this).balance, amount);\n        }\n        if (bytecode.length == 0) {\n            revert Create2EmptyBytecode();\n        }\n        /// @solidity memory-safe-assembly\n        assembly {\n            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)\n        }\n        if (addr == address(0)) {\n            revert Create2FailedDeployment();\n        }\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the\n     * `bytecodeHash` or `salt` will result in a new destination address.\n     */\n    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {\n        return computeAddress(salt, bytecodeHash, address(this));\n    }\n\n    /**\n     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at\n     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.\n     */\n    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address addr) {\n        /// @solidity memory-safe-assembly\n        assembly {\n            let ptr := mload(0x40) // Get free memory pointer\n\n            // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |\n            // |-------------------|---------------------------------------------------------------------------|\n            // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |\n            // | salt              |                                      BBBBBBBBBBBBB...BB                   |\n            // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |\n            // | 0xFF              |            FF                                                             |\n            // |-------------------|---------------------------------------------------------------------------|\n            // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |\n            // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |\n\n            mstore(add(ptr, 0x40), bytecodeHash)\n            mstore(add(ptr, 0x20), salt)\n            mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes\n            let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff\n            mstore8(start, 0xff)\n            addr := keccak256(start, 85)\n        }\n    }\n}\n"
}