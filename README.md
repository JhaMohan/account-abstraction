# About

1. Create a basic AA on Ethereum
2. Create a basic AA on zksync
3. Deploy and send a userOp / transaction through them



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
