const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  var instance;
  switch (network) {
    case 'kovan':
      instance = await deployProxy(WMLK, ['0xD90e51C3aFEc106b56bEf22c29723bbE059865ba'], { kind: 'uups' });
      break;
    case 'live':
      instance = await deployProxy(WMLK, ['0x582BC31227B1A9D9305084DA0ca0549Aa4a60E70'], { kind: 'uups' });
      break;
    default:
      instance = await deployProxy(WMLK, { kind: 'uups' });
  }
  console.log('Deployed', instance.address);
};
