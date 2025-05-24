// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GNGNToken is ERC20, AccessControl {
    bytes32 public constant GOVERNOR_ROLE = keccak256("GOVERNOR_ROLE");

    mapping(address => bool) public blacklisted;

    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);

    constructor() ERC20("G-Naira", "gNGN") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(GOVERNOR_ROLE, msg.sender);
    }

    modifier onlyGovernor() {
        require(hasRole(GOVERNOR_ROLE, msg.sender), "Not a GOVERNOR");
        _;
    }

    function blacklist(address account) external onlyGovernor {
        blacklisted[account] = true;
        emit Blacklisted(account);
    }

    function unblacklist(address account) external onlyGovernor {
        blacklisted[account] = false;
        emit Unblacklisted(account);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!blacklisted[msg.sender], "Sender is blacklisted");
        require(!blacklisted[recipient], "Recipient is blacklisted");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!blacklisted[sender], "Sender is blacklisted");
        require(!blacklisted[recipient], "Recipient is blacklisted");
        return super.transferFrom(sender, recipient, amount);
    }

    function mint(address to, uint256 amount) external onlyGovernor {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyGovernor {
        _burn(from, amount);
    }
}
