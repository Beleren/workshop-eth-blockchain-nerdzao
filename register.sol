pragma solidity >=0.5.1;

contract Register {
    address public owner;
    string private info;

    constructor() public {
        owner = msg.sender;
    }

    function setInfo(string memory _info) public {
        info = _info;
    }

    function getInfo() public view returns (string memory) {
        return info;
    }
       
}
