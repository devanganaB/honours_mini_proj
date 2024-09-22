// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Aadhaar {

    event userNotification(
        string field,
        address company,
        address indexed user
    );

    // Struct to store user Aadhaar data
    struct User_Aadhaar {
        string name; 
        string DOB;  
        string HomeAddress; 
        string gender; 
    }

    // Mapping to store Aadhaar data for each user
    mapping(address => User_Aadhaar) public aadhaarMapping;

    // Mappings to store access permissions for different fields
    mapping(address => address[]) public accessMappingName;
    mapping(address => address[]) public accessMappingDOB; 
    mapping(address => address[]) public accessMappingHomeAddress; 
    mapping(address => address[]) public accessMappingGender;

    // Helper function to check if a company already has access
    function _hasAccess(address[] storage accessList, address company) internal view returns (bool) {
        for (uint i = 0; i < accessList.length; i++) {
            if (accessList[i] == company) {
                return true;
            }
        }
        return false;
    }

    // Request access to name
    function requestAccessName(address userAddress) public {
        emit userNotification("name", msg.sender, userAddress);
    }

    // Grant access to name (only the user can grant access)
    // function grantAccessName(address userAddress) public {
    //     require(userAddress == msg.sender, "Only the user can grant access.");
    //     if (!_hasAccess(accessMappingName[userAddress], msg.sender)) {
    //         accessMappingName[userAddress].push(msg.sender);
    //     }
    // }
    function grantAccessName(address userAddress) public {
    require(userAddress == msg.sender, "Only the user can grant access.");
    bool isAlreadyGranted = false;
    for (uint i = 0; i < accessMappingName[userAddress].length; i++) {
        if (accessMappingName[userAddress][i] == msg.sender) { // Use msg.sender instead of tx.origin
            isAlreadyGranted = true;
            break;
          }
      }
      if (!isAlreadyGranted) {
          accessMappingName[userAddress].push(msg.sender); // Use msg.sender to add the company address
      }
  }


    // Request access to DOB
    function requestAccessDOB(address userAddress) public {
        emit userNotification("DOB", msg.sender, userAddress);
    }

    // Grant access to DOB (only the user can grant access)
    // function grantAccessDOB(address userAddress) public {
    //     require(userAddress == msg.sender, "Only the user can grant access.");
    //     if (!_hasAccess(accessMappingDOB[userAddress], msg.sender)) {
    //         accessMappingDOB[userAddress].push(msg.sender);
    //     }
    // }

    // Request access to home address
    function requestAccessHomeAddress(address userAddress) public {
        emit userNotification("HomeAddress", msg.sender, userAddress);
    }

    // Grant access to home address (only the user can grant access)
    // function grantAccessHomeAddress(address userAddress) public {
    //     require(userAddress == msg.sender, "Only the user can grant access.");
    //     if (!_hasAccess(accessMappingHomeAddress[userAddress], msg.sender)) {
    //         accessMappingHomeAddress[userAddress].push(msg.sender);
    //     }
    // }

    // Request access to gender
    function requestAccessGender(address userAddress) public {
        emit userNotification("Gender", msg.sender, userAddress);
    }

    // Grant access to gender (only the user can grant access)
    // function grantAccessGender(address userAddress) public {
    //     require(userAddress == msg.sender, "Only the user can grant access.");
    //     if (!_hasAccess(accessMappingGender[userAddress], msg.sender)) {
    //         accessMappingGender[userAddress].push(msg.sender);
    //     }
    // }

    function grantAccessDOB(address userAddress) public { 
    require(userAddress == msg.sender, "Only the user can grant access.");
    bool isAlreadyGranted = false;
    for (uint i = 0; i < accessMappingDOB[userAddress].length; i++) {
        if (accessMappingDOB[userAddress][i] == msg.sender) {
            isAlreadyGranted = true;
            break;
        }
    }
    if (!isAlreadyGranted) {
        accessMappingDOB[userAddress].push(msg.sender);
    }
}

function grantAccessHomeAddress(address userAddress) public {
    require(userAddress == msg.sender, "Only the user can grant access.");
    bool isAlreadyGranted = false;
    for (uint i = 0; i < accessMappingHomeAddress[userAddress].length; i++) {
        if (accessMappingHomeAddress[userAddress][i] == msg.sender) {
            isAlreadyGranted = true;
            break;
        }
    }
    if (!isAlreadyGranted) {
        accessMappingHomeAddress[userAddress].push(msg.sender);
    }
}

function grantAccessGender(address userAddress) public {
    require(userAddress == msg.sender, "Only the user can grant access.");
    bool isAlreadyGranted = false;
    for (uint i = 0; i < accessMappingGender[userAddress].length; i++) {
        if (accessMappingGender[userAddress][i] == msg.sender) {
            isAlreadyGranted = true;
            break;
        }
    }
    if (!isAlreadyGranted) {
        accessMappingGender[userAddress].push(msg.sender);
    }
}


    // Set Aadhaar data for a user
    function setUserAadhaar(
        string memory _name, 
        string memory _DOB, 
        string memory _homeAddress, 
        string memory _gender
    ) public {
        aadhaarMapping[msg.sender] = User_Aadhaar(_name, _DOB, _homeAddress, _gender);
    }
}
