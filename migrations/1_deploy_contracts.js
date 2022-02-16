const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  var instance;
  if (network != 'live') {
    instance = await deployProxy(WMLK, { kind: 'uups' });
  } else {
    // instance = await deployProxy(WMLK, ['0xWAPPER'], { kind: 'uups' });
  }
  console.log('Deployed', instance.address);
};
