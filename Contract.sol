// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Interaction Logger
/// @notice Records each call to `interact()` with the caller address and block timestamp.
/// @dev No imports, no constructor, and no input parameters anywhere.
contract InteractionLogger {
    /// @dev A single recorded interaction
    struct Interaction {
        address user;
        uint256 timestamp;
    }

    /// @dev Stored interactions in chronological order
    Interaction[] private interactions;

    /// @notice Emitted when a new interaction is recorded
    event InteractionRecorded(address indexed user, uint256 indexed timestamp, uint256 indexed index);

    /// @notice Record an interaction (no inputs).
    /// @dev Pushes a new Interaction to storage and emits an event.
    function interact() external {
        interactions.push(Interaction({ user: msg.sender, timestamp: block.timestamp }));
        emit InteractionRecorded(msg.sender, block.timestamp, interactions.length - 1);
    }

    /// @notice Returns the total number of recorded interactions.
    /// @dev No inputs.
    function totalInteractions() external view returns (uint256) {
        return interactions.length;
    }

    /// @notice Returns all user addresses that interacted so far.
    /// @dev No inputs. Returns a dynamic array of addresses.
    function getAllUsers() external view returns (address[] memory) {
        uint256 len = interactions.length;
        address[] memory addrs = new address[](len);
        for (uint256 i = 0; i < len; ++i) {
            addrs[i] = interactions[i].user;
        }
        return addrs;
    }

    /// @notice Returns all timestamps (block.timestamp) for recorded interactions.
    /// @dev No inputs. Returns a dynamic array of uint256 timestamps.
    function getAllTimestamps() external view returns (uint256[] memory) {
        uint256 len = interactions.length;
        uint256[] memory stamps = new uint256[](len);
        for (uint256 i = 0; i < len; ++i) {
            stamps[i] = interactions[i].timestamp;
        }
        return stamps;
    }

    /// @notice Convenience read: returns the most recent interaction's user and timestamp.
    /// @dev No inputs. If none recorded, returns zero-address and zero timestamp.
    function latestInteraction() external view returns (address user, uint256 timestamp) {
        uint256 len = interactions.length;
        if (len == 0) {
            return (address(0), 0);
        }
        Interaction storage it = interactions[len - 1];
        return (it.user, it.timestamp);
    }
}
