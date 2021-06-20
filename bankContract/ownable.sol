//Used for the destroyable contract

//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;

contract ownable{

  address payable owner; // declare the owner variable as an address type.

  modifier onlyOwner {
      require(msg.sender == owner); // Only the owner can execute this function
      _;  // proceed to run the function
  }

  constructor(){
      owner = msg.sender; // the address that deploys the contract
  }

}
