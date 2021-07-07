//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
​
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

​
contract NFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
​
    constructor(string name, string symbol) public ERC721(name, symbol) {}
​
    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();
​
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
​
        return newItemId;
    }
}