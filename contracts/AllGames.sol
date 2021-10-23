// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./OneGame.sol";
import "./States.sol";

contract AllGames is ERC721 {
    States states;
    constructor(States _states) ERC721("GameOfLife", "GoL") {
        states = _states;
    }
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    
    struct Single_Game {
        OneGame _gameContract;
        uint8 _counterInitialInputs;
        bool _alive;
        uint256 _tokenId;
    } 
    /// Mapping from tokenId to Games
    mapping(uint256 => Single_Game) public games;
    // Maping tokenId to state
    event StateChange(uint256 _tokenId, address _gameAddress, bool _alive, uint8 _counterInitialInputs);

    function inputState(uint256 _tokenId, uint[] memory _state) public {
        if (games[_tokenId]._alive == false) {
            games[_tokenId]._gameContract.mint(msg.sender, 10000000000000000000);
            games[_tokenId]._counterInitialInputs++;
            states.setState(_state, _tokenId);
            if (games[_tokenId]._counterInitialInputs == 10) {
                games[_tokenId]._alive = true;
            }
        } else {
            states.setState(_state, _tokenId);
        }
        emit StateChange(_tokenId, address(games[_tokenId]._gameContract), games[_tokenId]._alive, games[_tokenId]._counterInitialInputs);
    }

    function transitionToNewState(uint256 _tokenId) public {
        states.nextState(_tokenId);
        games[_tokenId]._gameContract.mint(msg.sender, 1000000000000000000);
        emit StateChange(_tokenId, address(games[_tokenId]._gameContract), games[_tokenId]._alive, games[_tokenId]._counterInitialInputs);
    }    

    function lastIndex() public view returns(uint) {
        return _tokenIdTracker.current();
    }
    
    function mint(uint[] memory _state) public {
        OneGame game = new OneGame(100000000000000000000, this, msg.sender);
        games[_tokenIdTracker.current()]._gameContract = game;
        games[_tokenIdTracker.current()]._tokenId = _tokenIdTracker.current();
        states.setState(_state, _tokenIdTracker.current());
        games[_tokenIdTracker.current()]._counterInitialInputs = 1;

        emit StateChange(_tokenIdTracker.current(), address(game), games[_tokenIdTracker.current()]._alive, games[_tokenIdTracker.current()]._counterInitialInputs);

        super._mint(address(game), _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }

    function getState(uint256 _tokenId) public returns(uint[] memory stateArray) {
        return states.getState(_tokenId);
    }
} 