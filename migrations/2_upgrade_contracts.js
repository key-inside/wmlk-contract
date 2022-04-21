const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  const instance = await WMLK.deployed(); // proxy
  instance = await upgradeProxy(instance.address, WMLK);
  console.log('Upgraded', instance.address);
};
