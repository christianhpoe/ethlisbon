// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract GolTransition {
    function transitionToNewState(string memory _state) public virtual returns(string memory) {
        /// TODO needs game of life logic
        bytes memory currentState = bytes(_state);
        bytes memory nextState = new bytes(currentState.length); 
        for (uint8 i = 0; i <= 100; i++) {
            if (currentState[i] == '1') {
                nextState[i+1] = '1';
            } else {
                nextState[i] = '.';
            }
        }
        return string(nextState);
    }
}