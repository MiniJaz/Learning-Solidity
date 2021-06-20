//ownable contract for multisigwallet

//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;
pragma abicoder v2;

contract msownable{
    
    address[] internal owners; //array of owners addresses
    uint internal requiredSigs; //number of signatures required
    bool internal isOwner; //boolean to determine if the sender is an owner

    modifier onlyOwners{
     // uint i=0; //set counter to 0
      //uint j=owners.length; //number of owners
      isOwner = false; //assume sender is not the owner

      // loop through the owners, if it matches the sender then set isOwner to true
      for(uint i=0; i < owners.length; i++){
           if (owners[i] == msg.sender){
              isOwner = true;
           }
      }
      require(isOwner == true, "You are not an owner");
      _;  // proceed
    }

}
