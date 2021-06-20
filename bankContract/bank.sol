//Example using payable, and transfer function

//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;

import "./destroyable.sol";

interface GovernmentInterface{
    /*Need to know what functions are available from the external contract and need whole function header (usually publicly available)
      Needs to be external. Do not need the function body - Govt contract executes it. If it returns anything, this would be included in the header*/
    
    function addTransaction(address _from, address _to, uint _amount) external;  
}

contract Bank is destroyable{
    //Initialise GovernmentInstance
    GovernmentInterface GovernmentInstance;
    
    constructor(address _govAddress){
        //create contract instance of the GovernmentInterface & specify the contract address.
        GovernmentInstance = GovernmentInterface(_govAddress);
    }

    mapping(address => uint) balance;

    event depositDone(uint amount, address indexed depositedTo);

    function deposit() public payable returns (uint)  {
        balance[msg.sender] += msg.value;
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint _amount) public returns (uint){
        require(balance[msg.sender] >= _amount);
        balance[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }

    function transfer(address payable _recipient, uint _amount) public {
        require(balance[msg.sender] >= _amount, "Balance not sufficient");
        require(msg.sender != _recipient, "Don't transfer money to yourself");

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, _recipient, _amount);

        // make call to the external contract
       GovernmentInstance.addTransaction(msg.sender,_recipient,_amount);

        assert(balance[msg.sender] == previousSenderBalance - _amount);
    }

    function _transfer(address from, address payable to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }

}

