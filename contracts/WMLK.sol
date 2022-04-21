// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract WMLK is Initializable, ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant WRAPPER_ROLE = keccak256("WRAPPER_ROLE");
    bytes32 public constant RECOVERER_ROLE = keccak256("RECOVERER_ROLE");

    mapping(bytes32 => bool) private _extIDs;

    event Wrapped(address indexed to, uint256 amount, bytes32 indexed extID);

    event Unwrapped(address indexed from, uint256 amount, address indexed extTo);

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
        _setupRole(RECOVERER_ROLE, msg.sender);
    }

    function decimals() public pure override returns (uint8) {
        return 8;
    }

    function cap() public pure returns (uint256) {
        return 986245419 * 10 ** 8;
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev Returns `true` if `extID` has been wrapped.
     */
    function wrapped(bytes32 extID) public view returns (bool) {
        return _extIDs[extID];
    }

    /**
     * @dev Wrap
     *
     * Emits {Wrapped} and {IERC20-Transfer} events.
     */
    function wrap(address to, uint256 amount, bytes32 extID) external onlyRole(WRAPPER_ROLE) returns (bool) {
        require(!wrapped(extID), "Wrapper: already wrapped external ID");
        require(amount > 0, "Wrapper: zero amount");

        _extIDs[extID] = true;
        _mint(to, amount);

        emit Wrapped(to, amount, extID);

        return true;
    }

    /**
     * @dev Unwrap
     *
     * See {_unwrap}
     */
    function unwrap(address extTo, uint256 amount) external returns (bool) {
        _unwrap(_msgSender(), extTo, amount);
        return true;
    }

    /**
     * @dev Moves `amount` of tokens mis-sent to this contract.
     *
     * Emits {IERC20-Transfer} events.
     */
    function recover(address to, uint256 amount, uint256 fee) external onlyRole(RECOVERER_ROLE) returns (bool) {
        super._transfer(address(this), to, amount);
        if (fee > 0) {
            super._transfer(address(this), _msgSender(), fee);
        }
        return true;
    }

    /**
     * @dev Unwraps `amount` of tokens mis-sent to this contract.
     *
     * Emits {Unwrapped} and {IERC20-Transfer} events.
     */
    function recoveryUnwrap(address extTo, uint256 amount, uint256 fee) external onlyRole(RECOVERER_ROLE) returns (bool) {
        _unwrap(address(this), extTo, amount);
        if (fee > 0) {
            super._transfer(address(this), _msgSender(), fee);
        }
        return true;
    }

    /**
     * @dev Destroys `amount` tokens from `account`.
     *
     * Emits {Unwrapped} and {IERC20-Transfer} events.
     */
    function _unwrap(address account, address extTo, uint256 amount) internal {
        require(amount > 0, "Wrapper: zero amount");

        _burn(account, amount);

        emit Unwrapped(account, amount, extTo);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal override {
        require(ERC20Upgradeable.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal onlyRole(UPGRADER_ROLE) override {}
}
