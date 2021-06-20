//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;
pragma abicoder v2;

import "./msownable.sol";

contract multiSig is msownable{

    constructor(address[] memory _owners, uint _requiredSigs) {
        require(_requiredSigs > 0, "Required signatures must be greater than 0");
        require(_owners.length >= _requiredSigs, "There must be more owners than required signatures");
        owners = _owners; //array of addresses
        requiredSigs = _requiredSigs; //set the number of signatures required to send a tx
    }
    
    struct Transaction {
        uint id; //id of the transaction
        address payable recipient; //address to send to
        uint amount; //amount
        uint signatures; //number of signatures already signed
        bool sent; //track whether the tx has been sent
     }

     Transaction[] transactions;  //array of transactions

    //double mapping Address => (TxID:true/false) keep track of which owners have signed
    mapping (address => mapping(uint => bool)) signatures;

    event depositDone(uint amount, address indexed depositedFrom); //deposit event
    event signed(uint TxID, address signer);  //signed event
    event transferred(uint TxID, address signer, uint amount);  //sent event

    //deposits into SC
    function deposit() public payable returns (uint){
        emit depositDone(msg.value, msg.sender);      //log event - who sent and how much
        return address(this).balance;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;         // return the balance of this address
    }
    
    function getTransaction(uint _TxID) public view returns(Transaction memory){
        return transactions[_TxID];         // return the chosen transaction
    }

    //create a transaction
    function createTransaction(uint _amount,address payable _recipient) public onlyOwners{
        require(address(this)!= _recipient, "Cannot send to yourself");

        uint TxID = transactions.length; //set TxID to start at 0

        transactions.push(
            Transaction(TxID,_recipient,_amount,0,false) // add transaction to the array, set signatures to 0, set sent status to false
            );
    }

    //sign a tx
    function sign(uint _TxID) public onlyOwners returns(uint){

        require(signatures[msg.sender][_TxID] == false, "You have already approved");
        require(transactions[_TxID].sent == false, "This transaction has already been sent!");

        signatures[msg.sender][_TxID] = true; //update signatures to track that this owner has signed

        transactions[_TxID].signatures += 1; //update transaction with number of signatures
        emit signed(_TxID,msg.sender);

        return transactions[_TxID].signatures; //return number of signatures
    }

    //send a tx
    function send(uint _TxID) public onlyOwners returns (uint){
        require(address(this).balance >= transactions[_TxID].amount, "Balance not sufficient");
        require(transactions[_TxID].signatures >= requiredSigs, "Not enough signatures");
        require(transactions[_TxID].sent == false, "This transaction has already been sent");

        transactions[_TxID].sent = true; //set status as sent
        transactions[_TxID].recipient.transfer(transactions[_TxID].amount); // send funds

        emit transferred(_TxID,transactions[_TxID].recipient,transactions[_TxID].amount);

        return address(this).balance;
    }
}
