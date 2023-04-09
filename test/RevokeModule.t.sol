// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";

import {RevokeModule} from "../src/RevokeModule.sol";
import {MockSafe} from "./MockSafe.sol";

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

contract CounterTest is Test {
    RevokeModule public revokeModule;
    MockSafe public safe;
    address public revoker;

    function setUp() public {
        safe = new MockSafe();
        revoker = address(1);

        revokeModule = new RevokeModule(address(safe), revoker);
    }

    function testResetERC20() public {
        ERC20PresetFixedSupply token = new ERC20PresetFixedSupply('test', 'TST', 100*1e18, address(safe));
        address exploitedAddress = address(2);

        //prepare
        uint256 approvedAmount = 1;
        vm.prank(address(safe));
        token.approve(exploitedAddress, approvedAmount);
        assertEq(approvedAmount, token.allowance(address(safe), exploitedAddress));

        //test
        vm.prank(revoker);
        revokeModule.revokeERC20(address(token), exploitedAddress);
        assertEq(0, token.allowance(address(safe), exploitedAddress));
    }

    function testResetERC20Permission() public {
        vm.expectRevert();
        revokeModule.revokeERC20(address(0), address(0));
    }

    function testResetERC721() public {
        ERC721PresetMinterPauserAutoId token = new ERC721PresetMinterPauserAutoId('test', 'TST', '');
        token.mint(address(safe));

        address exploitedAddress = address(2);

        //prepare
        vm.prank(address(safe));
        token.setApprovalForAll(exploitedAddress, true);
        assertEq(true, token.isApprovedForAll(address(safe), exploitedAddress));

        //test
        vm.prank(revoker);
        revokeModule.revokeERC721(address(token), exploitedAddress);
        assertEq(false, token.isApprovedForAll(address(safe), exploitedAddress));
    }

    function testResetERC721Permission() public {
        vm.expectRevert();
        revokeModule.revokeERC721(address(0), address(0));
    }

    function testResetERC721TokenId() public {
        ERC721PresetMinterPauserAutoId token = new ERC721PresetMinterPauserAutoId('test', 'TST', '');
        token.mint(address(safe));
        uint256 tokenId = 0;

        address exploitedAddress = address(2);

        //prepare
        vm.prank(address(safe));
        token.approve(exploitedAddress, tokenId);
        assertEq(exploitedAddress, token.getApproved(tokenId));

        //test
        vm.prank(revoker);
        revokeModule.revokeERC721(address(token), tokenId);
        assertEq(address(0), token.getApproved(tokenId));
    }

    function testResetERC721TokenIdPermission() public {
        vm.expectRevert();
        revokeModule.revokeERC721(address(0), 0);
    }

    function testResetERC1155() public {
        ERC1155PresetMinterPauser token = new ERC1155PresetMinterPauser('');
        uint256 tokenId = 1;
        token.mint(address(safe), tokenId, 123, '');

        address exploitedAddress = address(2);

        //prepare
        vm.prank(address(safe));
        token.setApprovalForAll(exploitedAddress, true);
        assertEq(true, token.isApprovedForAll(address(safe), exploitedAddress));

        //test
        vm.prank(revoker);
        revokeModule.revokeERC1155(address(token), exploitedAddress);
        assertEq(false, token.isApprovedForAll(address(safe), exploitedAddress));
    }

    function testResetERC1155Permission() public {
        vm.expectRevert();
        revokeModule.revokeERC721(address(0), address(0));
    }
}
