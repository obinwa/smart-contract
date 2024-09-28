//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Wallet {

    uint public balance;

    constructor() {
        balance = address(this).balance;
    }

    function withdrawToCaller(uint amount) public returns(string memory){
        if(amount <= balance){
            payable(msg.sender).transfer(amount);
            balance = balance - amount;
            return "successful";
        }else{
            return "Withdrawal Amount is greater than available balance";
        }
    }

    function withdrawToAccount(uint amount, address toAccount) public returns(string memory){
        if(amount <= balance){
            payable(toAccount).transfer(amount);
            balance = balance - amount;
            return "successful";
        }else{
            return "Withdrawal Amount is greater than available balance";
        }
    }

    function deposit() public payable{
        balance += msg.value;
    }

    receive() external payable {
        balance = balance + msg.value;
    }

    fallback() external {
        
    }


}

