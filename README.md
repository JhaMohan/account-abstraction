# About

1. Create a basic AA on Ethereum
2. Create a basic AA on zksync
3. Deploy and send a userOp / transaction through them

## Account Abstraction (AA) Smart Contract on Ethereum
created a minimal smart contract wallet that can handle transactions initiated via a bundler.

Key Concepts:
The wallet will accept transactions (UserOp) and execute them.
It must verify the sender and signature before processing.

## Create a Basic AA on zkSync
zkSync uses native account abstraction, so smart contracts can be deployed as accounts directly.


## Deploy and Send a UserOp
 To send a UserOp, we need:
  1. A Bundler (e.g., using eth_sendUserOperation)
  2. The EntryPoint contract
  3. A Signed Transaction
## Steps to Deploy & Send a Transaction:
1. Deploy the AA contract on Ethereum & zkSync.
2. Use a bundler to send a UserOp.
3. Execute a transaction from the smart contract wallet.


# to add console2.log in smart contract
```
$ import {console2} from "../../../../lib/forge-std/src/console2.sol"
```


# to debug the test in foundry

```shell
$ forge test --debug testEntryPointCanExecuteCommands
```

# To up zksync 
```shell
$ foundryup-zksync 
```

# ZKSYNC compile

```shell
$ forge build --zksync
```


# command to run test
```shell
$ forge test --mt testValidateTransaction --zksync --system-mode=true
$ forge test --mt testZkOwnerCanExecuteCommands --zksync --via-ir
```
