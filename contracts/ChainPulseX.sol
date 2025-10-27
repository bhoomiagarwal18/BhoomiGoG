// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChainPulseX
 * @dev A decentralized activity tracker that records and manages user transactions on-chain.
 */
contract ChainPulseX {
    struct Activity {
        address user;
        string action;
        uint256 timestamp;
    }

    Activity[] public activities;
    address public admin;

    event ActionRecorded(address indexed user, string action, uint256 timestamp);
    event AdminChanged(address oldAdmin, address newAdmin);

    constructor() {
        admin = msg.sender;
    }

    // Record a new user action
    function recordAction(string calldata _action) external {
        activities.push(Activity(msg.sender, _action, block.timestamp));
        emit ActionRecorded(msg.sender, _action, block.timestamp);
    }

    // Get total number of recorded actions
    function getActionCount() external view returns (uint256) {
        return activities.length;
    }

    // Change admin
    function changeAdmin(address _newAdmin) external {
        require(msg.sender == admin, "Only admin can change admin");
        emit AdminChanged(admin, _newAdmin);
        admin = _newAdmin;
    }
}
