const { forceImport } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  var proxyAddress = '';
  switch (network) {
    case 'kovan':
      proxyAddress = '0x378620EC61c41Ecdb2683a8F2355502a403b4785';
      break;
    case 'live':
      proxyAddress = '0xf87C4B9C0c1528147CAc4E05b7aC349A9Ab23A12';
      break;
    default :
      return console.error('Error: There is no proxy address.');
  }
  const instance = await forceImport(proxyAddress, WMLK, { kind: 'uups' });
  console.log('Imported', instance.address);
};
