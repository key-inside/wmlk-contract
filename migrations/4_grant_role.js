const { forceImport } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  const instance = await WMLK.deployed();
  const res = await instance.grantRole('', '');
  console.log(res);
};
