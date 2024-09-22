// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Aadhaar {

    event userNotification(
        string field,
        address company,
        address indexed user
    );
    

    // struct to store user aadhar
    struct User_Aadhaar {
        string name; 
        string DOB;  
        string HomeAddress; 
        string gender; 
    }

    mapping(address => User_Aadhaar) public aadhaarMapping; // mapping which maps user_address to his struct Aadhar

    mapping(address => address[]) public accessMappingName; // mapping whihc maps user_address to the list of address which can access the user data. Used for the access modifiier
    mapping(address => address[]) public accessMappingDOB; 
    mapping(address => address[]) public accessMappingHomeAddress; 
    mapping(address => address[]) public accessMappingGender; 


    function requestAccessName(address userAddress) public { // function used by company to request access

      emit userNotification("name", msg.sender, userAddress);
    }

    
    function grantAccessName(address userAddress) public {
    require(userAddress == msg.sender, "Only the user can grant access.");
    bool isAlreadyGranted = false;
    for (uint i = 0; i < accessMappingName[userAddress].length; i++) {
        if (accessMappingName[userAddress][i] == tx.origin) {
            isAlreadyGranted = true;
            break;
        }
    }
    if (!isAlreadyGranted) {
        accessMappingName[userAddress].push(tx.origin);
    }
    }


    function requestAccessDOB(address userAddress) public { // function used by company to request access
      emit userNotification("DOB", msg.sender, userAddress);
    }

    function grantAccessDOB(address userAddress) public { 
      accessMappingDOB[userAddress].push(msg.sender);

    }
    function requestAccessHomeAddress(address userAddress) public { // function used by company to request access
        emit userNotification("HomeAddress", msg.sender, userAddress);
    }
    function grantAccessHomeAddress(address userAddress) public {
      accessMappingHomeAddress[userAddress].push(msg.sender);

    }
    function requestAccessGender(address userAddress) public { // function used by company to request access
        emit userNotification("Gender", msg.sender, userAddress);
    }
     function grantAccessGender(address userAddress) public { 
      accessMappingGender[userAddress].push(msg.sender);

    }

    function setUserAadhaar(string memory _name, string memory _DOB, string memory _homeAddress, string memory _gender) public {
    aadhaarMapping[msg.sender] = User_Aadhaar(_name, _DOB, _homeAddress, _gender);
    }

}