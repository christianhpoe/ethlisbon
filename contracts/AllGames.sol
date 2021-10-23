// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./OneGame.sol";

contract AllGames is ERC721, Ownable {
    constructor() ERC721("GameOfLife", "GoL") {}
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    
    struct Single_Game {
        OneGame _gameContract;
        uint8 _counterInitialInputs;
        bool _alive;
        uint256 _tokenId;
        string _state;
    }
    
    /// Mapping from tokenId to Games
    mapping(uint256 => Single_Game) public games;
    
    event StateChange(uint256 _tokenId, string _state, address _gameAddress, bool _alive, uint8 _counterInitialInputs);
    
    /// All Inputs go here
    function inputState(uint256 _tokenId, string memory _state) public {
        if (games[_tokenId]._alive == false) {
            _initialInputs(_tokenId, _state);
        } else {
            _laterInputs(_tokenId, _state);
        }
        emit StateChange(_tokenId, _state, address(games[_tokenId]._gameContract), games[_tokenId]._alive, games[_tokenId]._counterInitialInputs);
    }

    function transitionToNewState(uint256 _tokenId) public {
        games[_tokenId]._gameContract.mint(msg.sender, 1000000000000000000);
        emit StateChange(_tokenId, games[_tokenId]._state, address(games[_tokenId]._gameContract), games[_tokenId]._alive, games[_tokenId]._counterInitialInputs);
    }

    // Set State to _state; Mint ERC20Token to msg.sender, counter + 1; If counter = 10 game alive
    function _initialInputs(uint256 _tokenId, string memory _state) private {
        require(games[_tokenId]._alive == false, "The game is already alive");
        games[_tokenId]._state = _state;
        games[_tokenId]._gameContract.mint(msg.sender, 10000000000000000000);
        games[_tokenId]._counterInitialInputs++;
        if (games[_tokenId]._counterInitialInputs == 10) {
            games[_tokenId]._alive = true;
        }
    }

    function _laterInputs(uint256 _tokenId, string memory _state) private {
        require(games[_tokenId]._alive == true, "The game is not yet alive");
        /// TODO require payment of ERC20 Tokens  
        /// TODO Burn Tokens by sending to nonce;
        games[_tokenId]._state = _state;
    }

    function lastIndex() public view returns(uint) {
        return _tokenIdTracker.current();
    }
    
    function mint(string memory _state) public onlyOwner {
        OneGame game = new OneGame(100000000000000000000, this, msg.sender);
        games[_tokenIdTracker.current()]._gameContract = game;
        games[_tokenIdTracker.current()]._tokenId = _tokenIdTracker.current();
        games[_tokenIdTracker.current()]._state = _state;
        games[_tokenIdTracker.current()]._counterInitialInputs = 1;

        emit StateChange(_tokenIdTracker.current(), _state, address(game), games[_tokenIdTracker.current()]._alive, games[_tokenIdTracker.current()]._counterInitialInputs);

        super._mint(address(game), _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }
} 