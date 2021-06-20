//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;

// saves txs that have happened

contract Government{
   //transaction structure
    struct Transaction{
        address from;
        address to;
        uint amount;
        uint txID;
    }
    
    //array to hold the tx objects
    Transaction[] transactionLog;

    function addTransaction(address _from, address _to, uint _amount) external {    
          transactionLog.push(Transaction(_from,_to,_amount, transactionLog.length));
    }
    
    function getTransaction(uint _index) public view returns(address, address, uint) { // cannot return a struct so need to output elements of the struct.
        return (transactionLog[_index].from, transactionLog[_index].to, transactionLog[_index].amount);
    }
}
