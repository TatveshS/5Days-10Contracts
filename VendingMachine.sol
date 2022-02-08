// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract VendingMachine{
    address public Owner;
    mapping(address => uint) public donutBalances;

    constructor(){
        Owner = msg.sender;
        donutBalances[address(this)] =100;
    }

    function getVendingMachineBalance() public view returns(uint){
        return donutBalances[address(this)];
    }

    function restock(uint amount) public {
        require(msg.sender == Owner,"You are not Owner");
        donutBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable{
        require(msg.value >= amount * 2 ether , "You must pay atleast 2 ether per donut");
        require(donutBalances[address(this)] >= amount,"Not enough Donuts in stock to fulfill your request");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }
}
