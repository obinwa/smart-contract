//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Wallet {

    uint balance;
    string passphrase;
    mapping(address => bool) guardianAccounts;
    mapping(address => uint) allowance;
    bool isLoggedIn;

    constructor(string memory accountPassphrase, address payable guardian1, address payable  guardian2) {
        balance = address(this).balance;
        passphrase = accountPassphrase;
        guardianAccounts[guardian1] = true;
        guardianAccounts[guardian2] = true;
    }

    function checkBalance() public view returns(uint){
        require(isLoggedIn, "You have to login");
        return balance;
    }

    function withdrawAllFunds() public {
        require(guardianAccounts[msg.sender], "Wallet transfer cannot be done to non-guardian account");
        payable(msg.sender).transfer(balance);
    }

    function login(string memory accountPassphrase) public {
        require(compareStrings(accountPassphrase, passphrase), "Invalid passphrase");
        isLoggedIn = true;
    }

    function updateAllowance(uint amount, address payable account) public{
        require(isLoggedIn, "You have to login");
        allowance[account] = amount;
    }

    function withdrawToCaller(uint amount) public {
        require(isLoggedIn, "You have to login");
        require(allowance[msg.sender] >= amount, "Withdrawal Amount is greater than available allowance");
        require(balance >= amount, "Withdrawal Amount is greater than available balance");
        
        balance -= amount;
        allowance[msg.sender]  -= amount;
        payable(msg.sender).transfer(amount); 
    }

    function withdrawToAccount(uint amount, address payable toAccount) public {
        require(isLoggedIn, "You have to login");
        require(allowance[toAccount] >= amount,  "Withdrawal Amount is greater than available allowance");
        require(balance >= amount, "Withdrawal Amount is greater than available balance");

        balance -= amount;
        allowance[toAccount] -= amount;
        toAccount.transfer(amount);
    }

    function deposit() public payable{
        balance += msg.value;
    }

    receive() external payable {
        balance = balance + msg.value;
    }

    fallback() external payable  {
        balance = balance + msg.value;
    }

    function compareStrings(string memory s1, string memory s2) pure internal returns (bool) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }


}

