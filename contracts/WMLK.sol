// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract WMLK is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant WRAPPER_ROLE = keccak256("WRAPPER_ROLE");

    mapping(bytes32 => bool) private _extTxHashes;

    event Wrapped(address account, uint256 amount, bytes32 extTxHash);

    event Unwrapped(address account, uint256 amount, address extAccount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize() public initializer {
        __initialize(msg.sender);
    }

    function initialize(address wrapper) public initializer {
        __initialize(wrapper);
    }

    function __initialize(address wrapper) internal {
        __ERC20_init("Wrapped MiL.k", "WMLK");
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
        _setupRole(WRAPPER_ROLE, wrapper);
    }

    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev Returns `true` if `extTxHash` has been wrapped.
     */
    function wrapped(bytes32 extTxHash) public view returns (bool) {
        return _extTxHashes[extTxHash];
    }

    /**
     * @dev Wrap
     *
     * Emits {Wrapped} and {IERC20-Transfer} events.
     */
    function wrap(address account, uint256 amount, bytes32 extTxHash) public onlyRole(WRAPPER_ROLE) returns (bool) {
        require(!wrapped(extTxHash), "Wrapper: already wrapped external tx");
        require(amount > 0, "Wrapper: zero amount");

        _extTxHashes[extTxHash] = true;
        _mint(account, amount);

        emit Wrapped(account, amount, extTxHash);

        return true;
    }

    /**
     * @dev Unwrap
     *
     * Emits {Unwrapped} and {IERC20-Transfer} events.
     */
    function unwrap(address extAccount, uint256 amount) public returns (bool) {
        require(amount > 0, "Wrapper: zero amount");

        _burn(_msgSender(), amount);

        emit Unwrapped(_msgSender(), amount, extAccount);

        return true;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {}
}
