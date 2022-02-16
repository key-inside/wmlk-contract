const { upgradeProxy } = require('@openzeppelin/truffle-upgrades');

const WMLK = artifacts.require('WMLK');

module.exports = async function (deployer, network) {
  var proxyAddress = '';
  switch (network) {
    case 'kovan':
      proxyAddress = '0x378620EC61c41Ecdb2683a8F2355502a403b4785';
      break;
    case 'live':
    default :
      return console.error('Error: There is no proxy address.');
  }
  const instance = await upgradeProxy(proxyAddress, WMLK);
  console.log('Upgraded', instance.address);
};
