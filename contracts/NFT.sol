// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721.sol";

contract NFT is ERC721, Ownable {
    // Incremental id of the next minted token
    uint private _nextTokenId = 1;

    //TODO: should this timestamp be private?
    // A tokenURI became visible after this timestamp
    uint private immutable _timestamp;
    string private _contractURI;
    string private _stubURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory contractUri,
        string memory stubURI,
        string[] memory ownerTokensURIs,
        string[] memory recipientTokensURIs,
        address recipient,
        uint timestamp
    ) public ERC721(name, symbol) {
        for (uint i = 0; i < ownerTokensURIs.length; i++) {
            mint(msg.sender, ownerTokensURIs[i]);
        }
        for (uint i = 0; i < recipientTokensURIs.length; i++) {
            mint(recipient, recipientTokensURIs[i]);
        }
        _stubURI = stubURI;
        _contractURI = contractUri;
        _timestamp = timestamp;
    }

    function mint(address to, string memory tokenURI)
        public
        onlyOwner
        returns (uint tokenId)
    {
        tokenId = _nextTokenId;
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        _nextTokenId++;
    }

    function tokenURI(uint tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        // Show a tokenURI of a token if the `_timestamp` is earlier than `now` else show a stub
        return _timestamp <= now ? _tokenURIs[tokenId] : _stubURI;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }
}
