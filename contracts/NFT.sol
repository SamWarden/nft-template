// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, Ownable {
    // Incremental id of the next minted token
    uint private _nextTokenId;

    //TODO: should this timestamp be private?
    // A tokenURI became visible after this timestamp
    uint private immutable _timestamp;
    string private _contractURI;
    string private _stubURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseUri,
        string memory contractUri,
        string memory stubURI,
        uint timestamp,
        uint tokenAmountForOwner,
        uint tokenAmountForRecipient,
        address recipient
    ) public ERC721(name, symbol) {
        uint nextTokenId = 1;
        for (; nextTokenId <= tokenAmountForOwner; nextTokenId++) {
            _mint(msg.sender, nextTokenId);
        }
        for (; nextTokenId <= tokenAmountForRecipient; nextTokenId++) {
            _mint(recipient, nextTokenId);
        }
        _nextTokenId = nextTokenId;
        _setBaseURI(baseUri);
        _stubURI = stubURI;
        _contractURI = contractUri;
        _timestamp = timestamp;
    }

    function mint(address to)
        public
        onlyOwner
        returns (uint tokenId)
    {
        tokenId = _nextTokenId;
        _mint(to, tokenId);
        _nextTokenId++;
    }

    function tokenURI(uint tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        //TODO: should be blackBoxURI here?
        // Concatenate the tokenID to the baseURI and show it if the `_timestamp` is earlier than `now` else show a stub
        return _timestamp <= now ?
            string(abi.encodePacked(baseURI(), tokenId.toString(), ".json")) : _stubURI;
    }

    // Override it to hide the `_baseURI` value until the `_timestamp`
    function baseURI() public view override returns (string memory) {
        return _timestamp <= now ? ERC721.baseURI() : _stubURI;
    }

    //TODO: should this value be hidden?
    function contractURI() public view returns (string memory) {
        return _contractURI;
    }
}
