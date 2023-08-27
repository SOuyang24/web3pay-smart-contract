// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "hardhat/console.sol";
contract Venmo {
    //Define the Owner of the smart contract
    /**
    address holds the 20 byte value representing the size of an Ethereum address
    An address can be used to get the balance using .balance method and can be used to transfer balance to another address using .transfer method.
     */
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //Create Struct and Mapping for request, transaction and name
    
    // request
    struct request {
        address requestor;
        uint256 amount;
        string message;
        string name;
    }
    // transaction 
    struct sendReceive {
        string action;
        uint amount;
        string message;
        address otherPartyAddress;
        string otherPartyName;
    }
    // name
    struct userName {
        string name;
        bool hasName;
    }
    // Mapping is a reference type as arrays and structs. 
    // mapping (_keyType => _valueType) 
    mapping(address => userName) names;
    mapping(address => request[]) requests;
    mapping(address => sendReceive[]) history;

    //Add a name to wallent address
    function addName(string memory _name) public {
        userName storage newUserName = names[msg.sender];
        newUserName.name = _name;
        newUserName.hasName = true;
    }

    //Create a Request for the payment
    function createRequest(address user, uint256 _amount, string memory _message) public {
        request memory newRequest;
        newRequest.requestor = msg.sender;
        newRequest.amount = _amount;
        newRequest.message = _message;
        if (names[msg.sender].hasName) {
            newRequest.name = names[msg.sender].name;
        }
        requests[user].push(newRequest);
    }

    //Pay a Request _request is an index value in the request array
    function payRequest(uint256 _request) public payable {
        //require function effectively, you can validate inputs, enforce conditions, and enhance the overall integrity of your contract’s logic. 
        require(_request < requests[msg.sender].length, "No Such Request");
        request[] storage myRequests = requests[msg.sender];
        request storage payableRequest = myRequests[_request];
        uint256 toPay = payableRequest.amount * 1000000000000000000;
        console.log("toPay amount is %s and msg.value is %s", toPay, msg.value);
        require(msg.value == (toPay), "Pay Correct Amount");
        // payable functions in Solidity are functions that let a smart contract accept Ether.
        payable(payableRequest.requestor).transfer(msg.value);
        // add history information to sender and receiver address respectively
        addHistory(msg.sender, payableRequest.requestor, 
        payableRequest.amount, payableRequest.message);
        // swap the last request with the reqest we already paid
        myRequests[_request] = myRequests[myRequests.length - 1];
        // remove the request we already paid
        myRequests.pop();
    }

    // private function that is only used by payRequest function
    function addHistory(address sender, address receiver, uint256 _amount, string memory _message) private {
        // add history record in the history record array for the sender
        sendReceive memory newSend;
        newSend.action = "-";
        newSend.amount = _amount;
        newSend.message = _message;
        newSend.otherPartyAddress = receiver;
        if (names[receiver].hasName) {
            newSend.otherPartyName = names[receiver].name;
        }
        history[sender].push(newSend);

// add history record in the history record array for the receiver
        sendReceive memory newReceiver;
        newReceiver.action = "+";
        newReceiver.amount = _amount;
        newReceiver.message = _message;
        newReceiver.otherPartyAddress = sender;
        if (names[sender].hasName) {
            newReceiver.otherPartyName = names[sender].name;
        }
        history[receiver].push(newReceiver);
    }

    //Get all requests sent to a User
    function getMyRequests(address _user) public view returns(
        address[] memory, // address
        uint256[] memory, // amount
        string[] memory, //name
        string[] memory //messages
    ) {
        address[] memory addresses = new address[](requests[_user].length);
        uint256[] memory amounts = new uint256[](requests[_user].length); 
        string[] memory nms = new string[](requests[_user].length);
        string[] memory messages = new string[](requests[_user].length); 

        for (uint i = 0; i < requests[_user].length; i++) {
            request storage myRequest = requests[_user][i];
            addresses[i] = myRequest.requestor;
            amounts[i] = myRequest.amount;
            messages[i] = myRequest.message;
            nms[i] = myRequest.name;
        }
        return (addresses, amounts, messages, nms);           
    }

    //Get all historic transactions user has been apart of
    function getMyHistory(address _user) public view returns(sendReceive[] memory) {
        return history[_user];
    }
    
    // Get the name for the user
    function getMyName(address _user) public view returns(userName memory) {
        return names[_user];
    }
}

