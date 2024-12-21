// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {ZkMinimalAccount} from "src/zksync/ZkMinimalAccount.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {Transaction,MemoryTransactionHelper} from "lib/foundry-era-contracts/src/system-contracts/contracts/libraries/MemoryTransactionHelper.sol";
import {BOOTLOADER_FORMAL_ADDRESS} from "lib/foundry-era-contracts/src/system-contracts/contracts/Constants.sol";
import {ACCOUNT_VALIDATION_SUCCESS_MAGIC} from "lib/foundry-era-contracts/src/system-contracts/contracts/interfaces/IAccount.sol";
// oz imports
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";


contract ZkMinimalAccountTest is Test{
  ZkMinimalAccount zkMinimalAccount;
  ERC20Mock usdc;

  uint256 constant AMOUNT = 1e18;
  bytes32 constant EMPTY_BYTES32 = bytes32(0);
  address ANVIL_DEFAULT_ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

  function setUp() public {
    zkMinimalAccount = new ZkMinimalAccount();
    zkMinimalAccount.transferOwnership(ANVIL_DEFAULT_ACCOUNT);
    usdc = new ERC20Mock();
    vm.deal(address(zkMinimalAccount),AMOUNT);
  }

  function testZkOwnerCanExecuteCommands() public {
      // Arrange
      address dest = address(usdc);
      uint256 value =0;
      bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(zkMinimalAccount),AMOUNT);

      Transaction memory transaction = _createUnsignedTransaction(zkMinimalAccount.owner(),113,dest,value,functionData);

      // Act
      vm.prank(zkMinimalAccount.owner());
      zkMinimalAccount.executeTransaction(EMPTY_BYTES32,EMPTY_BYTES32,transaction);
      // Assert
      assertEq(usdc.balanceOf(address(zkMinimalAccount)),AMOUNT);
   }


   function testValidateTransaction() public {
    // Arrange
     address dest = address(usdc);
      uint256 value =0;
      bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector,address(zkMinimalAccount),AMOUNT);

      Transaction memory transaction = _createUnsignedTransaction(zkMinimalAccount.owner(),113,dest,value,functionData);
      transaction = _signTransaction(transaction);
    // Act
    vm.prank(BOOTLOADER_FORMAL_ADDRESS);
    bytes4 magic = zkMinimalAccount.validateTransaction(EMPTY_BYTES32,EMPTY_BYTES32,transaction);
    // Assert
    assertEq(magic,ACCOUNT_VALIDATION_SUCCESS_MAGIC);
   }

     /*//////////////////////////////////////////////////////////////
                            HELPER FUNCTION
    //////////////////////////////////////////////////////////////*/

    function _signTransaction(Transaction memory _transaction) internal view returns(Transaction memory) {
      bytes32 transactionHash = MemoryTransactionHelper.encodeHash(_transaction);
     

       uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 ANVIL_DEFAULT_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, transactionHash);
         Transaction memory signedTransaction = _transaction;
        signedTransaction.signature = abi.encodePacked(r, s, v);

        return signedTransaction;
    }

    function _createUnsignedTransaction(address from,uint8 transactionType,address to,uint256 value,bytes memory data) internal view returns(Transaction memory) {
      uint256 nonce = vm.getNonce(address(zkMinimalAccount));
      bytes32[] memory factoryDeps = new bytes32[](0);
      return Transaction({
        txType: transactionType,
        from: uint256(uint160(from)),
        to: uint256(uint160(to)),
        gasLimit: 16777216,
        gasPerPubdataByteLimit:16777216,
        maxFeePerGas:16777216,
        maxPriorityFeePerGas:16777216,
        paymaster:0,
        nonce:nonce,
        value:value,
        reserved: [uint256(0),uint256(0),uint256(0),uint256(0)],
        data:data,
        signature:hex"",  
        factoryDeps:factoryDeps,
        paymasterInput:hex"",
        reservedDynamic:hex""
      });
    }
}