// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract States is Ownable{
    // TokenIds to State
    mapping(uint256 => mapping(uint256 => bool)) public states;

    uint[] stateArray;
    mapping(uint256 => mapping(uint256 => bool)) public newStates;

    constructor() {}

    function nextState(uint256 _tokenId) public {
        
        for(uint i = 0; i < 100; i++) {
            
            uint aliveNeighbors = 0;
            
            /// Cell not touching any edges
            if (i > 9 && i < 90 && (i+1)%10 != 1 && (i+1)%10 != 0) {
                
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
            
            // Top row 
            if (i < 10) {
                if (i == 0) { // top left
                    // right neighbor
                    if (states[_tokenId][i+1] == true) {
                        aliveNeighbors++;
                    }
                    // bottom neighbor
                    if (states[_tokenId][i+10] == true) {
                        aliveNeighbors++;
                    }
                    // bottom right neighbor
                    if (states[_tokenId][i+11] == true) {
                        aliveNeighbors++;
                    }
                } else if (i == 9) { // top right
                    // left neighbor
                    if (states[_tokenId][i-1] == true) {
                        aliveNeighbors++;
                    }
                    // bottom neighbor
                    if (states[_tokenId][i+10] == true) {
                        aliveNeighbors++;
                    }
                    // bottom left neighbor
                    if (states[_tokenId][i+9] == true) {
                        aliveNeighbors++;
                    }
                } else { // top middle cells
                    // left neighbor
                    if (states[_tokenId][i-1] == true) {
                        aliveNeighbors++;
                    }
                    // right neighbor
                    if (states[_tokenId][i+1] == true) {
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
            }
            
            // Bottom row 
            if (i >= 90) {
                if (i == 90) { // bottom left
                    // right neighbor
                    if (states[_tokenId][i+1] == true) {
                        aliveNeighbors++;
                    }
                    // top neighbor
                    if (states[_tokenId][i-10] == true) {
                        aliveNeighbors++;
                    }
                    // top right neighbor
                    if (states[_tokenId][i-9] == true) {
                        aliveNeighbors++;
                    }
                } else if (i == 99) { // bottom right
                    // left neighbor
                    if (states[_tokenId][i-1] == true) {
                        aliveNeighbors++;
                    }
                    // top neighbor
                    if (states[_tokenId][i-10] == true) {
                        aliveNeighbors++;
                    }
                    // top left neighbor
                    if (states[_tokenId][i-11] == true) {
                        aliveNeighbors++;
                    }
                } else { // bottom middle cells
                    // left neighbor
                    if (states[_tokenId][i-1] == true) {
                        aliveNeighbors++;
                    }
                    // right neighbor
                    if (states[_tokenId][i+1] == true) {
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
                }
            }
            
            // left column
            if ((i+1)%10 == 0 && i>10 && i<90) {
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
                // top right neighbor
                if (states[_tokenId][i-9] == true) {
                    aliveNeighbors++;
                }
                // bottom right neighbor
                if (states[_tokenId][i+11] == true) {
                    aliveNeighbors++;
                }
            }
            
            // right column
            if ((i+1)%10 == 1 && i>10 && i<90) {
                // left neighbor
                if (states[_tokenId][i-1] == true) {
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
                // bottom left neighbor
                if (states[_tokenId][i+9] == true) {
                    aliveNeighbors++;
                }
            }
        
            /// Given number of alive neighbors move to next state
            if (states[_tokenId][i] == true) {
                if (aliveNeighbors == 2 || aliveNeighbors == 3) {
                    newStates[_tokenId][i] = true;
                } else {
                    newStates[_tokenId][i] = false;
                }
            } else {
                if (aliveNeighbors == 3) {
                    newStates[_tokenId][i] = true;
                } else {
                    newStates[_tokenId][i] = false;
                }
            }
        }
        for (uint i = 0; i < 100; i++) {
           states[_tokenId][i] = newStates[_tokenId][i]; 
        }
    }
    

    function setState(uint[] memory input, uint256 _tokenId) public {
        for(uint i=0; i<input.length; ++i) {
            if (input[i] == 0) {
                states[_tokenId][i] = false;
            } else {
                states[_tokenId][i] = true;
            }
            newStates[_tokenId][i] = states[_tokenId][i];
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