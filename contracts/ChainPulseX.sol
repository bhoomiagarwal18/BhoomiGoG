Record a new user action
    function recordAction(string calldata _action) external {
        activities.push(Activity(msg.sender, _action, block.timestamp));
        emit ActionRecorded(msg.sender, _action, block.timestamp);
    }

    Change admin
    function changeAdmin(address _newAdmin) external {
        require(msg.sender == admin, "Only admin can change admin");
        emit AdminChanged(admin, _newAdmin);
        admin = _newAdmin;
    }
}
// 
update
// 
