## Inspiration
Conceptual art that explores possibilities of collectively creating and governing the art, as well as investigating the concept of evolving systems over time in the realm of NFTs

## What it does
To initiate Conway's Game of Life, 10 anons must come together and provide input for the initial state. The anons will receive ERC20 tokens as a reward for bringin the system alive. The tokens represent the fractionalized ownership of the NFT which they collectively generated. The system evolves over time by calling the a state transition function for which one is rewarded with more ERC20 tokens. An anon may also choose anarchy and change the state. But anarchy has a price! Choosing to change the state at will costs ERC20 tokens. 

## How we built it
#### Solidity Smart Contracts
- ERC721 Contract for NFTs
- ERC20 Contract for fractionalizing NFTs, who is owner of ERC721 Token
- State Contract for changing state of Conway's Game of Life through user input or computed state transitions
#### Frontend
- Vue-Nuxt App using web3 to connect to deployed Smart Contracts rendering Grid of Game State
- Allowing Users to Create a new Game, give new state inputs and triggering computational state transitions

## Challenges we ran into
- Contract Byte Size 
- gas optimization, especially to store state of game

## Accomplishments that we're proud of
- Getting it off the ground with little experience! 
- Having a fully working dApp, with a frontend that the players can use to trigger on-chain nft state transitions.

## What we learned
Contracts have a limited Bytesize lol

## What's next for Collective Game of Life
- Creating more collaborative forms of on-chain governance around the collective ownership of the NFT
- Making on-chain storage more efficient to simulate larger worlds.
- Working on improving the front-end experience
- Exploring ways of on-chain making the art more beautiful, as opposed to just storing state
