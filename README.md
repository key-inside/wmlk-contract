# Wrapped MLK token contract

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
truffle(develop)> wt.deposited('0x2dda34f2183b84cebfa93b2c47e0db3c889b1543f26c5f317ce3f6ab46e66a1e')
truffle(develop)> (await wt.balanceOf('0xc4b50dd1042c8e7c5837ae084beafe9c28213233')).toString()
```
