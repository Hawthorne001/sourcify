{
  "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v5.0.0) (proxy/beacon/IBeacon.sol)\n\npragma solidity ^0.8.20;\n\n/**\n * @dev This is the interface that {BeaconProxy} expects of its beacon.\n */\ninterface IBeacon {\n    /**\n     * @dev Must return an address that can be used as a delegate call target.\n     *\n     * {UpgradeableBeacon} will check that this address is a contract.\n     */\n    function implementation() external view returns (address);\n}\n"
}