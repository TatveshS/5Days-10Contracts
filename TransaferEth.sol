// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract TransferEth{
    address public Owner;
    uint public total;

    constructor() payable{
        Owner = msg.sender;
        total = msg.value;
    }

    function transfer(address payable _to, uint _value) public payable{
        require(_to != msg.sender,"No point in sending ether to your own account");
        (bool success, ) = _to.call{value: _value}("");
        require(success, "Failed to send Ether");
    }
}
