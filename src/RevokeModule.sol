// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./IGnosisSafe.sol";

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract RevokeModule is AccessControl {
    bytes32 public constant REVOKER_ROLE = keccak256("safe.roles.revoker");

    IGnosisSafe public safe;

    //TODO make proxyable w/ initializer
    constructor(address _safe, address _revoker) {
        safe = IGnosisSafe(_safe);
        
        // admin is the safe
        _grantRole(DEFAULT_ADMIN_ROLE, _safe);

        _grantRole(REVOKER_ROLE, _revoker);
    }

    /// @dev Revoke spender from ERC20
    /// @param tokenAddress Token to reset allowance
    /// @param spender Spender to reset
    function revokeERC20(
        address tokenAddress,
        address spender
    ) external onlyRole(REVOKER_ROLE) {
        require(safe.execTransactionFromModule(tokenAddress, 0, abi.encodeCall(IERC20.approve, (spender, 0)), Enum.Operation.Call), "Module transaction failed");
    }

    /// @dev Revoke spender from ERC721
    /// @param tokenAddress Token to reset allowance
    /// @param operator Operator to reset
    function revokeERC721(
        address tokenAddress,
        address operator
    ) external onlyRole(REVOKER_ROLE) {
        require(safe.execTransactionFromModule(tokenAddress, 0, abi.encodeCall(IERC721.setApprovalForAll, (operator, false)), Enum.Operation.Call), "Module transaction failed");
    }

    /// @dev Revoke any spender from ERC721 on a specific tokenId
    /// @param tokenAddress Token to reset allowance
    /// @param tokenId Token id to reset
    function revokeERC721(
        address tokenAddress,
        uint256 tokenId
    ) external onlyRole(REVOKER_ROLE) {
        require(safe.execTransactionFromModule(tokenAddress, 0, abi.encodeCall(IERC721.approve, (address(0), tokenId)), Enum.Operation.Call), "Module transaction failed");
    }

    /// @dev Revoke spender from ERC1155
    /// @param tokenAddress Token to reset allowance
    /// @param operator Operator to reset
    function revokeERC1155(
        address tokenAddress,
        address operator
    ) external onlyRole(REVOKER_ROLE) {
        require(safe.execTransactionFromModule(tokenAddress, 0, abi.encodeCall(IERC1155.setApprovalForAll, (operator, false)), Enum.Operation.Call), "Module transaction failed");
    }
}
