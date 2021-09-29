const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer) {
  const instance = await deployProxy(WMLK, { kind: 'uups' });
  console.log('Deployed', instance.address);
};
