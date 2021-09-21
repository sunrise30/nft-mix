// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721URIStorage, VRFConsumerBase {

  bytes32 internal keyHash;
  uint256 public fee;
  uint256 public tokenCounter;

  enum Breed {
    PUG,
    SHIBA_INU,
    ST_BERNARD
  }

  mapping(bytes32 => address) public requestIdToSender;
  mapping(bytes32 => string) public requestIdToTokenURI;
  mapping(uint256 => Breed) public tokenIdToBreed;
  mapping(bytes32 => uint256) public requestIdToTokenId;
  event requestedCollectible(bytes32 indexed requestId);

  constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
  VRFConsumerBase(_VRFCoordinator, _LinkToken)
  ERC721("Doggies", "DOG") {
    keyHash = _keyhash;
    fee = 0.1 * 10 ** 18; // 0.1 LINK
    tokenCounter = 0;
  }

  function createCollectible(string memory _tokenURI)
  public returns (bytes32) {
    bytes32 requestId = requestRandomness(keyHash, fee);
    requestIdToSender[requestId] = msg.sender;
    requestIdToTokenURI[requestId] = _tokenURI;
    emit requestedCollectible(requestId);
  }

  function fulfillRandomness(bytes32 _requestId, uint256 _randomNumber) internal override {
    address dogOwner = requestIdToSender[_requestId];
    string memory tokenURI = requestIdToTokenURI[_requestId];
    uint256 newItemId = tokenCounter;
    _safeMint(dogOwner, newItemId);
    _setTokenURI(newItemId, tokenURI);
    Breed breed = Breed(_randomNumber % 3);
    tokenIdToBreed[newItemId] = breed;
    requestIdToTokenId[_requestId] = newItemId;
    tokenCounter = tokenCounter + 1;
  }

  function setTokenURI(uint256 _tokenId, string memory _tokenURI) public {
    require(
      _isApprovedOrOwner(_msgSender(), _tokenId),
      "ERC721: transfer caller is not owner nor approved"
    );
    _setTokenURI(_tokenId, _tokenURI);
  }
}
