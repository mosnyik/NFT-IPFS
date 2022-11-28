// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract LW3Punks is ERC721Enumerable, Ownable{
using Strings for uint256;

/**
 * @dev _baseTokenURI for computing {tokenURI} : if set, the base URI for each token would be 
 * concatenation of 'baseURI' and the 'tokenId'.
 */

string _baseTokenURI; 

// the _price of one LW3Punks NFT
uint256 public _price = 0.01 ether;

// used to _paused the contract incase of emergency

bool public _paused;

// max number of LW3Punks NFT
uint256 public maxTokenIds = 10;

// total number of tokenIds minted
uint256 public tokenIds;

/**
 * check if the contract is paused, if true, return the error message,
 * otherwise run the code the modifier is used on.
 * NOTE: the modifier code runs first. 
 * */ 
modifier OnlyWhenNotPaused{
require(!_paused, 'Contract currently paused');
_;
}
 /**
  * @dev The LW3Punks Constructor takes the baseURI which is used to 
  * set as the _baseTokenURI for the collection.
  * The ERC721 constructor takes in a 'name' and a 'symbol' for the NFT Collection
  */

   constructor (string memory baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = baseURI;
    }

 /**
  * the mint function allows a user to mint 1 NFT per transaction
  */

 function mint () public payable OnlyWhenNotPaused{
    // the max amount of NFTs to be minted must not have been minted already before this call
    require(tokenIds< maxTokenIds, 'Exceeded max LW3Punks supply');
    // the user must pay '_price' (0.01ETH) to mint an NFT
    require(msg.value >= _price, 'Ether sent is not correct');
    // increament the (token minted count) 'tokenIds'
    tokenIds +=1;

    // mint LW3P NFT to the callers 'address' using the present 'tokenId'
    _safeMint(msg.sender, tokenIds);
 }

 /**
  * In our LW3P constructor, we take a 'baseURI' and set it as the '_baseTokenURI' of our NFT Collection
  * Here we would use the '_baseURI' to override the Openzeppelin's default inplementaion of ERC271 
  * which returns an empty string as baseURI, and set 'basseURI' to '_baseTokenURI' 
  */
 function _baseURI() internal view virtual override returns(string memory){
    return _baseTokenURI;
 }

 /**
  * @dev we override the Openzeppelin's ERC721 implementation of the tokenURI function
  * NOTE the 'tokenURI' refers to the token's Universal Resource Identifier which is 
  * used to locate the NFT on IPFS
  * So the '_tokenURI' function returns the the URI to which we need to add the tokenId 
  * do extract its metadata
  */
 function _tokenURI(uint256 tokenId) public view virtual returns (string memory){
    // use the 'tokenId' given to check for the NFTs metadata and return error if it doesnot exist
    require(_exists(tokenId), 'ERC721Metadata: URI query for nonexisting token');

    /**
     * set the return value of '_baseURI()' which we have set to the URI we recieved when called the 
     * LW3P constructor
     */
    string memory baseURI = _baseURI();

    /**
     *  check if the 'baseURI' given is greater that 0, 
     * if false, return an empty string
     * if true, return the the baseURI, attach the tokenId to it and add '.json' at the end 
     * so that it know the location of the token on IPFS based on the tokenId
     *  */ 
    return bytes(baseURI).length > 0 ? string (abi.encodePacked(baseURI, tokenId.toString(), '.json')): '';


 }

// use setPaused to pause or unpause the contract
 function setPaused(bool val) public onlyOwner{
    _paused = val;
 }

/**
 * withdraw sends all the ETH in the contract to the owner of the contract
 */
 function withdraw () public onlyOwner{
    // set the address of the owner
    address _owner = owner();

    // set the totall balance in the contract
    uint256 amount = address(this).balance;

    // send the contract balance to the owner of the contract
    (bool sent, ) = _owner.call{value: amount}('');

    // check if sending is successful
    require(sent, 'Failed to send Ethers');
 }


// function that helps us recieve Ether when msg.sender is empty
 receive() external payable{}

// function that helps us recieve Ether when msg.sender is not empty
 fallback()external payable{}

}