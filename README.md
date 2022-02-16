# Wrapped MLK (WMLK) token contract

ERC20 based token for wrapping MLK.

## Upgradeable contract

- UUPS proxy pattern ([EIP1822](https://eips.ethereum.org/EIPS/eip-1822))
- [OpenZeppelin Truffle Upgrades API](https://docs.openzeppelin.com/upgrades-plugins/1.x/api-truffle-upgrades)

## Installation

```sh
% npm install
```

## Compile

```sh
% truffle compile
```

## Run 

Run local dev node and console
```sh
% truffle develop
```

Migrate (complie & deploy)
```
truffle(develop)> migrate
```

Example
```
truffle(develop)> wt = await WMLK.deployed()
truffle(develop)> wt.address
truffle(develop)> wt.wrap('0xc4b50dd1042c8e7c5837ae084beafe9c28213233', '12300000000', '0x2dda34f2183b84cebfa93b2c47e0db3c889b1543f26c5f317ce3f6ab46e66a1e')
truffle(develop)> wt.wrapped('0x2dda34f2183b84cebfa93b2c47e0db3c889b1543f26c5f317ce3f6ab46e66a1e')
truffle(develop)> (await wt.balanceOf('0xc4b50dd1042c8e7c5837ae084beafe9c28213233')).toString()
```

## Migration
```sh
% truffle migrate --network kovan
// specific files
% truffle migrate -f 2 --to 2 --network kovan
```

## Source Code Flatten (for Verification)

1. Go [Remix Ethereum IDE](https://remix.ethereum.org/)
2. Create a contract source file in the contracts folder
3. Add the module version to import statements
```solidity
import "@openzeppelin/contracts-upgradeable@4.5.1/...
```
4. Choose the compiler version and compile
5. Add the 'FLATTENER' plugin and use it
