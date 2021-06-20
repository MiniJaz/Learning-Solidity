//“SPDX-License-Identifier: UNLICENSED”
pragma solidity 0.7.5;

import "./ownable.sol";

contract destroyable is ownable{

function destroy() public onlyOwner {
    selfdestruct(owner); // sends funds to owner's address, contract's data is cleared freeing up space in the Ethereum blockchain
    }

}
