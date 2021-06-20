//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;
pragma abicoder v2;

import "./msownable.sol";

contract multiSig is msownable{

    constructor(address[] memory _owners, uint _requiredSigs) {
        require(_requiredSigs > 0, "Required signatures must be greater than 0");
        require(_owners.length >= _requiredSigs, "There must be more owners than required signatures");
        owners = _owners; // the address that deploys the contract i.e. the first sender
        requiredSigs = _requiredSigs; //set the number of signatures required to send a tx
    }
    
    struct Transfer {
        uint id; //id of the transfer
        address payable recipient; //address to send to
        uint amount; //amount
        uint signatures; //number of signatures already signed
        bool sent; //track whether the tx has been sent
     }

     Transfer[] transfers;  //array of transfers

    //double mapping Address => (transferID:true/false) keep track of which owners have signed
    mapping (address => mapping(uint => bool)) signatures;

    event depositDone(uint amount, address indexed depositedFrom); //deposit event
    event signed(uint transferID, address signer);  //signed event
    event transferred(uint transferID, address signer, uint amount);  //sent event

    //deposits into SC
    function deposit() public payable returns (uint){
        emit depositDone(msg.value, msg.sender);      //log event - who sent and how much
        return address(this).balance;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;         // return the balance of this address
    }

    //create a transaction
    function createTransfer(uint _amount,address payable _recipient) public onlyOwners{
        require(address(this)!= _recipient, "Cannot send to yourself");

        uint TxID = transfers.length; //set transactionID to start at 0

        transfers.push(
            Transfer(TxID,_recipient,_amount,0,false) // add transfer to the array, set signatures to 0, set sent status to false
            );
    }

    //sign a tx
    function sign(uint _TransferID) public onlyOwners returns(uint){

        require(signatures[msg.sender][_TransferID] == false, "You have already approved");
        require(transfers[_TransferID].sent == false, "This transfer has already been sent!");

        signatures[msg.sender][_TransferID] = true; //update signatures to track that this owner has signed

        transfers[_TransferID].signatures += 1; //update transfer to update the number of signatures
        emit signed(_TransferID,msg.sender);

        return transfers[_TransferID].signatures; //return number of signatures
    }

    //send a tx
    function send(uint _TransferID) public onlyOwners returns (uint){
        require(address(this).balance >= transfers[_TransferID].amount, "Balance not sufficient");
        require(transfers[_TransferID].signatures >= requiredSigs, "Not enough signatures");
        require(transfers[_TransferID].sent == false, "This transaction has already been sent");

        transfers[_TransferID].sent = true; //set status as sent
        transfers[_TransferID].recipient.transfer(transfers[_TransferID].amount); // send funds

        emit transferred(_TransferID,transfers[_TransferID].recipient,transfers[_TransferID].amount);

        return address(this).balance;
    }
}
