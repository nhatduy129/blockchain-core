// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "hardhat/console.sol";

contract Karu is ERC721EnumerableUpgradeable, OwnableUpgradeable {
    mapping(uint256 => bool) public locked;

    function mint() public payable {
        require(msg.value == 10, "You need to pay ether");
        (bool transferred, ) = owner().call{value: msg.value}("");
        require(transferred, "Transfer failed");
        uint256 _tokenId = totalSupply();
        _mint(msg.sender, _tokenId);
    }

    modifier mutex(uint256 param) {
        require(!locked[param], "It is currently locked, please try again");
        console.log("mutex 1");
        locked[param] = true;
        console.log("mutex 2");
        _;
        locked[param] = false;
        console.log("mutex 3");
    }

    function buy(uint256 _tokenId) public payable mutex(_tokenId) {
        require(ownerOf(_tokenId) == owner(), "This NFT is unavailable");
        console.log("buy 1");
        require(msg.value == 10, "You need to pay ether");
        console.log("buy 2");
        (bool transferred, ) = owner().call{value: msg.value}("");
        require(transferred, "Transfer failed");
        _transfer(owner(), msg.sender, _tokenId);
        console.log("buy 3");
    }
}
