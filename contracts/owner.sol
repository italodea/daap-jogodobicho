// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

contract Owned{
    address payable owner;

    constructor(){
        owner = msg.sender;
    }

    event OwnershipTransferred(address old, address newAddress);

    modifier onlyOwner{
        require(msg.sender == owner, "Somente o dono do contrato pode executar isso!");
        _;
    }

    function transferOwnership(address payable newOwner) public onlyOwner{
        _tranferOwnership(newOwner);
    }

    function _tranferOwnership(address payable newOwner) internal{
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract Mortal is Owned{
    function destroy() public onlyOwner{
        selfdestruct(owner);
    }
}
