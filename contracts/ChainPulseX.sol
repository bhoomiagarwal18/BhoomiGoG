// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title ChainPulseX
 * @dev On-chain heartbeat tracker for addresses and services
 * @notice Accounts can send periodic pulses, and observers can check liveness status
 */
contract ChainPulseX {
    address public owner;

    // Address => last pulse timestamp
    mapping(address => uint256) public lastPulseAt;

    // Optional label per address (e.g., service name, node id)
    mapping(address => string) public labels;

    // Global configuration
    uint256 public maxStaleDuration; // in seconds; after this, heartbeat is considered stale

    event PulseSent(address indexed account, uint256 timestamp, string label);
    event LabelUpdated(address indexed account, string label);
    event MaxStaleDurationUpdated(uint256 newDuration);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(uint256 _maxStaleDuration) {
        owner = msg.sender;
        require(_maxStaleDuration > 0, "Duration = 0");
        maxStaleDuration = _maxStaleDuration;
    }

    /**
     * @dev Send a heartbeat pulse for msg.sender
     * @param label Optional label to store/update for this address
     */
    function pulse(string calldata label) external {
        lastPulseAt[msg.sender] = block.timestamp;

        if (bytes(label).length > 0) {
            labels[msg.sender] = label;
            emit LabelUpdated(msg.sender, label);
        }

        emit PulseSent(msg.sender, block.timestamp, label);
    }

    /**
     * @dev Owner can set or update label for any address (e.g., for system-managed identities)
     */
    function setLabel(address account, string calldata label) external onlyOwner {
        labels[account] = label;
        emit LabelUpdated(account, label);
    }

    /**
     * @dev Check if an address is considered "live"
     * @param account Address to check
     * @return live True if lastPulseAt within maxStaleDuration
     * @return lastTs Last pulse timestamp
     */
    function isLive(address account) external view returns (bool live, uint256 lastTs) {
        lastTs = lastPulseAt[account];
        if (lastTs == 0) {
            return (false, 0);
        }
        live = (block.timestamp - lastTs) <= maxStaleDuration;
    }

    /**
     * @dev Update the maximum stale duration (in seconds)
     */
    function updateMaxStaleDuration(uint256 newDuration) external onlyOwner {
        require(newDuration > 0, "Duration = 0");
        maxStaleDuration = newDuration;
        emit MaxStaleDurationUpdated(newDuration);
    }

    /**
     * @dev Transfer contract ownership
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        address prev = owner;
        owner = newOwner;
        emit OwnershipTransferred(prev, newOwner);
    }
}
