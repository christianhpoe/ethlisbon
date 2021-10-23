// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract States is Ownable{
    // TokenIds to State
    mapping(uint256 => mapping(uint256 => bool)) public states;
    uint[] stateArray;

    constructor() {}
    function nextState(uint256 _tokenId) public {
        uint aliveNeighbors;
        for(uint i = 0; i < 100; i++) {
            
            aliveNeighbors = 0;
            
            /// Cell not touallching any edges
            if (i > 9 && i < 90 && (i+1)%10 != 1 && (i+1)%10 != 0)  {
                
                // left neighbor
                if (states[_tokenId][i-1] == true) {
                    aliveNeighbors++;
                }
                // right neighbor
                if (states[_tokenId][i+1] == true) {
                    aliveNeighbors++;
                }
                // top neighbor
                if (states[_tokenId][i-10] == true) {
                    aliveNeighbors++;
                }
                // bottom neighbor
                if (states[_tokenId][i+10] == true) {
                    aliveNeighbors++;
                }
                // top left neighbor
                if (states[_tokenId][i-11] == true) {
                    aliveNeighbors++;
                }
                // top right neighbor
                if (states[_tokenId][i-9] == true) {
                    aliveNeighbors++;
                }
                // bottom left neighbor
                if (states[_tokenId][i+9] == true) {
                    aliveNeighbors++;
                }
                // bottom right neighbor
                if (states[_tokenId][i+11] == true) {
                    aliveNeighbors++;
                }
            }
            
            /// Given number of alive neighbors move to next state
            if (states[_tokenId][i] == true) {
                if (aliveNeighbors == 2 || aliveNeighbors == 3) {
                    states[_tokenId][i] = true;
                } else {
                    states[_tokenId][i] = false;
                }
            } else {
                if (aliveNeighbors == 3) {
                    states[_tokenId][i] = true;
                } else {
                    states[_tokenId][i] = false;
                }
            }
        }
    }
    

    function setState(uint[] memory input, uint256 _tokenId) public {
        for(uint i=0; i<input.length; ++i) {
            if (input[i] == 0) {
                states[_tokenId][i] = false;
            } else {
                states[_tokenId][i] = true;
            }
        }
    }
    
    function getState(uint256 _tokenId) public returns(uint[] memory) {
        delete stateArray;
        for(uint i = 0; i < 100; i++) {
            if (states[_tokenId][i] == false) {
                stateArray.push(0);
            } else {
                stateArray.push(1);
            }
        }
        return stateArray;
    }
    
}