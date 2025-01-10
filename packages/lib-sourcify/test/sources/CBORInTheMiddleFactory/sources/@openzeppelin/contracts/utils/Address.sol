{
  "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v5.0.0) (utils/Address.sol)\n\npragma solidity ^0.8.20;\n\n/**\n * @dev Collection of functions related to the address type\n */\nlibrary Address {\n    /**\n     * @dev The ETH balance of the account is not enough to perform the operation.\n     */\n    error AddressInsufficientBalance(address account);\n\n    /**\n     * @dev There's no code at `target` (it is not a contract).\n     */\n    error AddressEmptyCode(address target);\n\n    /**\n     * @dev A call to an address target failed. The target may have reverted.\n     */\n    error FailedInnerCall();\n\n    /**\n     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to\n     * `recipient`, forwarding all available gas and reverting on errors.\n     *\n     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost\n     * of certain opcodes, possibly making contracts go over the 2300 gas limit\n     * imposed by `transfer`, making them unable to receive funds via\n     * `transfer`. {sendValue} removes this limitation.\n     *\n     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].\n     *\n     * IMPORTANT: because control is transferred to `recipient`, care must be\n     * taken to not create reentrancy vulnerabilities. Consider using\n     * {ReentrancyGuard} or the\n     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].\n     */\n    function sendValue(address payable recipient, uint256 amount) internal {\n        if (address(this).balance < amount) {\n            revert AddressInsufficientBalance(address(this));\n        }\n\n        (bool success, ) = recipient.call{value: amount}(\"\");\n        if (!success) {\n            revert FailedInnerCall();\n        }\n    }\n\n    /**\n     * @dev Performs a Solidity function call using a low level `call`. A\n     * plain `call` is an unsafe replacement for a function call: use this\n     * function instead.\n     *\n     * If `target` reverts with a revert reason or custom error, it is bubbled\n     * up by this function (like regular Solidity function calls). However, if\n     * the call reverted with no returned reason, this function reverts with a\n     * {FailedInnerCall} error.\n     *\n     * Returns the raw returned data. To convert to the expected return value,\n     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].\n     *\n     * Requirements:\n     *\n     * - `target` must be a contract.\n     * - calling `target` with `data` must not revert.\n     */\n    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n        return functionCallWithValue(target, data, 0);\n    }\n\n    /**\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n     * but also transferring `value` wei to `target`.\n     *\n     * Requirements:\n     *\n     * - the calling contract must have an ETH balance of at least `value`.\n     * - the called Solidity function must be `payable`.\n     */\n    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n        if (address(this).balance < value) {\n            revert AddressInsufficientBalance(address(this));\n        }\n        (bool success, bytes memory returndata) = target.call{value: value}(data);\n        return verifyCallResultFromTarget(target, success, returndata);\n    }\n\n    /**\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n     * but performing a static call.\n     */\n    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n        (bool success, bytes memory returndata) = target.staticcall(data);\n        return verifyCallResultFromTarget(target, success, returndata);\n    }\n\n    /**\n     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],\n     * but performing a delegate call.\n     */\n    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n        (bool success, bytes memory returndata) = target.delegatecall(data);\n        return verifyCallResultFromTarget(target, success, returndata);\n    }\n\n    /**\n     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target\n     * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an\n     * unsuccessful call.\n     */\n    function verifyCallResultFromTarget(\n        address target,\n        bool success,\n        bytes memory returndata\n    ) internal view returns (bytes memory) {\n        if (!success) {\n            _revert(returndata);\n        } else {\n            // only check if target is a contract if the call was successful and the return data is empty\n            // otherwise we already know that it was a contract\n            if (returndata.length == 0 && target.code.length == 0) {\n                revert AddressEmptyCode(target);\n            }\n            return returndata;\n        }\n    }\n\n    /**\n     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the\n     * revert reason or with a default {FailedInnerCall} error.\n     */\n    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {\n        if (!success) {\n            _revert(returndata);\n        } else {\n            return returndata;\n        }\n    }\n\n    /**\n     * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.\n     */\n    function _revert(bytes memory returndata) private pure {\n        // Look for revert reason and bubble it up if present\n        if (returndata.length > 0) {\n            // The easiest way to bubble the revert reason is using memory via assembly\n            /// @solidity memory-safe-assembly\n            assembly {\n                let returndata_size := mload(returndata)\n                revert(add(32, returndata), returndata_size)\n            }\n        } else {\n            revert FailedInnerCall();\n        }\n    }\n}\n"
}