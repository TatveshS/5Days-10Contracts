// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Attendace{
    uint public totalStudents;
    uint totalPresent;
    address teacher;

    mapping(address => bool) Present_in_class;

    constructor(){
        teacher = msg.sender;
    }

    function yesMadam(address studentId) public{
        require(!Present_in_class[studentId],"already atended");
        Present_in_class[studentId] = true; 
        totalPresent++;    
    }

    function absent() view public returns(uint){
        return (totalStudents - totalPresent);
    }

    
}
