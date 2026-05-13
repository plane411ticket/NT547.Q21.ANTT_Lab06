// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BadVault {
    mapping(address => uint) public balances;
    address public owner;
    bool public pause;

    constructor() {
        owner = msg.sender;
    }

    modifier whenNotPause()
    {
        require(!pause, "Contract is paused");        _;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value; // Sửa: Sử dụng msg.sender
    }

    function withdraw() public {
        uint amount = balances[msg.sender];

        require(amount > 0);
        
        balances[msg.sender] = 0; // Sửa: Trừ tiền trước khi chuyển tiền
        
        (bool success, ) = msg.sender.call{value: amount}(""); 

        require(success, "Transfer failed");
    }
    
    // function destroy() public onlyOwner(){
    //     selfdestruct(payable(owner)); // Lỗi: Dangerous & Deprecated
    // }
    function pauseContract() public {
        require(msg.sender == owner, "Only owner can pause the contract"); // Sửa: Chỉ cho phép pause contract bởi owner/ Không destruct contract nữa
        pause = true;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}