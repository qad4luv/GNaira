// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract GNGNToken is ERC20, AccessControl {
    bytes32 public constant GOVERNOR_ROLE = keccak256("GOVERNOR_ROLE");

    mapping(address => bool) public blacklisted;

    event Blacklisted(address indexed account);
    event Unblacklisted(address indexed account);
    event MintProposed(address indexed to, uint256 amount, uint256 proposalId);
    event BurnProposed(address indexed from, uint256 amount, uint256 proposalId);
    event ProposalApproved(uint256 proposalId, address approver);
    event ProposalExecuted(uint256 proposalId);

    uint256 public proposalCount;
    uint256 public constant QUORUM = 2; // 2-of-N multisig

    struct Proposal {
        address target;
        uint256 amount;
        uint256 approvals;
        bool executed;
        mapping(address => bool) approvedBy;
        bool isMint;
    }

    mapping(uint256 => Proposal) private proposals;

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

    function proposeMint(address to, uint256 amount) external onlyGovernor returns (uint256) {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.target = to;
        p.amount = amount;
        p.isMint = true;
        emit MintProposed(to, amount, proposalCount);
        return proposalCount;
    }

    function proposeBurn(address from, uint256 amount) external onlyGovernor returns (uint256) {
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.target = from;
        p.amount = amount;
        p.isMint = false;
        emit BurnProposed(from, amount, proposalCount);
        return proposalCount;
    }

    function approveProposal(uint256 proposalId) external onlyGovernor {
        Proposal storage p = proposals[proposalId];
        require(!p.executed, "Already executed");
        require(!p.approvedBy[msg.sender], "Already approved");

        p.approvedBy[msg.sender] = true;
        p.approvals++;
        emit ProposalApproved(proposalId, msg.sender);

        if (p.approvals >= QUORUM) {
            p.executed = true;
            if (p.isMint) {
                _mint(p.target, p.amount);
            } else {
                _burn(p.target, p.amount);
            }
            emit ProposalExecuted(proposalId);
        }
    }
}
