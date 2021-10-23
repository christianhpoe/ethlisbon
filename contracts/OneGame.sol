// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AllGames.sol";

contract OneGame is ERC20, Ownable {
    AllGames parentContract;
    
    constructor(uint256 initialSupply, AllGames _parentContract, address _initialTo) ERC20("Game of Life", "OneGoL") {
        parentContract = _parentContract;
        _mint(_initialTo, initialSupply);
    }

    function mint(address _to, uint amount) public onlyOwner {
        super._mint(_to, amount);
    }
}
