// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../src/IGnosisSafe.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract MockSafe is IGnosisSafe, ERC1155Holder {
    using Address for address;

    /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
    /// @param to Destination address of module transaction.
    /// @param value Ether value of module transaction.
    /// @param data Data payload of module transaction.
    /// @param operation Operation type of module transaction.
    function execTransactionFromModule(
        address to,
        uint256 value,
        bytes calldata data,
        Enum.Operation operation
    ) external override returns (bool success) {
        if(operation == Enum.Operation.Call) {
            to.functionCallWithValue(data, value);
        } else {
            to.functionDelegateCall(data);
        }

        return true;
    }
}