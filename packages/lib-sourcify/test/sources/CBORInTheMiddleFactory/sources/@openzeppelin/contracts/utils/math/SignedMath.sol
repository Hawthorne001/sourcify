{
  "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/SignedMath.sol)\n\npragma solidity ^0.8.20;\n\n/**\n * @dev Standard signed math utilities missing in the Solidity language.\n */\nlibrary SignedMath {\n    /**\n     * @dev Returns the largest of two signed numbers.\n     */\n    function max(int256 a, int256 b) internal pure returns (int256) {\n        return a > b ? a : b;\n    }\n\n    /**\n     * @dev Returns the smallest of two signed numbers.\n     */\n    function min(int256 a, int256 b) internal pure returns (int256) {\n        return a < b ? a : b;\n    }\n\n    /**\n     * @dev Returns the average of two signed numbers without overflow.\n     * The result is rounded towards zero.\n     */\n    function average(int256 a, int256 b) internal pure returns (int256) {\n        // Formula from the book \"Hacker's Delight\"\n        int256 x = (a & b) + ((a ^ b) >> 1);\n        return x + (int256(uint256(x) >> 255) & (a ^ b));\n    }\n\n    /**\n     * @dev Returns the absolute unsigned value of a signed value.\n     */\n    function abs(int256 n) internal pure returns (uint256) {\n        unchecked {\n            // must be unchecked in order to support `n = type(int256).min`\n            return uint256(n >= 0 ? n : -n);\n        }\n    }\n}\n"
}