pragma solidity 0.5.2;  

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol';

contract Token is ERC20Mintable{
        string public name = "Go Horse";
        string public symbol = "XGH";
        uint8 public decimals = 2;
}