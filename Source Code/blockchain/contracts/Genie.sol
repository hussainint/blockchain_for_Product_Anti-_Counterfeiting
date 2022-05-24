// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract Genie{
    uint public taskCount;

    struct User{
        address adres;
        string uid;
    }
    mapping(string => User) public ownership;
 
    constructor(){
        
    }

    function addProductOwnership(string memory _productQR,
    string memory _uid,
    address  _address) public{
        ownership[_productQR] = User(_address,_uid);
    }

    function getProductDetails(string memory _productQR)public view returns(string memory) {
        return ownership[_productQR].uid;
    }

    function transferOwnership(string memory _productQR,string memory _uid,address _address)public{
        ownership[_productQR] = User(_address,_uid);
    }
}