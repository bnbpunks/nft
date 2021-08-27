//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @dev {ERC721} token, including:
 *
 *  - ability for holders to burn (destroy) their tokens
 *  - a minter role that allows for token minting (creation)
 *  - token ID and URI autogeneration
 *
 * This contract uses {AccessControl} to lock permissioned functions using the
 * different roles - head to its documentation for details.
 *
 * The account that deploys the contract will be granted the minter and pauser
 * roles, as well as the default admin role, which will let it grant both minter
 * and pauser roles to other accounts.
 */
contract BNBPunks is Context,  AccessControlEnumerable, ERC721Enumerable, ERC721URIStorage{
  using Counters for Counters.Counter;
  Counters.Counter public _tokenIdTracker;

  string private _baseTokenURI;
  uint private _price;
  uint private _max;
  address private _admin;

  uint256 public reflectionBalance;
  uint256 public totalDividend;
  mapping(uint256 => uint256) lastDividendAt;
  mapping (uint256 => address ) public creator;

  /**
    * @dev Grants `DEFAULT_ADMIN_ROLE` to the
    * account that deploys the contract.
    *
    * Token URIs will be autogenerated based on `baseURI` and their token IDs.
    * See {ERC721-tokenURI}.
    */
  constructor(string memory name, string memory symbol, string memory baseTokenURI, uint mintPrice, uint max, address admin) ERC721(name, symbol) {
      _baseTokenURI = baseTokenURI;
      _price = mintPrice;
      _max = max;
      _admin = admin;

      _setupRole(DEFAULT_ADMIN_ROLE, admin);
  }

  function _baseURI() internal view virtual override returns (string memory) {
      return _baseTokenURI;
  }

  function setBaseURI(string memory baseURI) external {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "BNBPunks: must have admin role to change base URI");
    _baseTokenURI = baseURI;
  }

  function setTokenURI(uint256 tokenId, string memory _tokenURI) external {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "BNBPunks: must have admin role to change token URI");
    _setTokenURI(tokenId, _tokenURI);
  }

  function setPrice(uint mintPrice) external {
    require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "BNBPunks: must have admin role to change price");
    _price = mintPrice;
  }

  function price() public view returns (uint) {
    return _price;
  }

  function mint() public payable {
    require(msg.value == _price, "BNBPunks: must send correct price");
    require(_tokenIdTracker.current() < _max, "BNBPunks: all BNBPunks have been minted");

    _mint(msg.sender, _tokenIdTracker.current());
    creator[_tokenIdTracker.current()] = msg.sender;
    lastDividendAt[_tokenIdTracker.current()] = totalDividend;
    _tokenIdTracker.increment();
    splitBalance(msg.value);
  }

  function punkCreator(uint256 tokenId) public view returns(address){
    return creator[tokenId];
  }

  function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
    return ERC721URIStorage._burn(tokenId);
  }

  function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return ERC721URIStorage.tokenURI(tokenId);
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
    if (totalSupply() > tokenId) claimReward(tokenId);
    super._beforeTokenTransfer(from, to, tokenId);
  }

  /**
    * @dev See {IERC165-supportsInterface}.
    */
  function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function currentRate() public view returns (uint256){
      if(totalSupply() == 0) return 0;
      return reflectionBalance/totalSupply();
  }

  function claimRewards() public {
    uint count = balanceOf(msg.sender);
    for(uint i=0; i < count; i++){
        uint tokenId = tokenOfOwnerByIndex(msg.sender, i);
        claimReward(tokenId);
    }
  }

  function getReflectionBalances() public view returns(uint256) {
    uint count = balanceOf(msg.sender);
    uint256 total = 0;
    for(uint i=0; i < count; i++){
        uint tokenId = tokenOfOwnerByIndex(msg.sender, i);
        total += getReflectionBalance(tokenId);
    }
    return total;
  }

  function claimReward(uint256 tokenId) public {
    require(ownerOf(tokenId) == _msgSender(), "BNBPunks: Only owner can claim rewards");
    uint256 balance = getReflectionBalance(tokenId);
    payable(ownerOf(tokenId)).transfer(balance);
    lastDividendAt[tokenId] = totalDividend;
  }

  function getReflectionBalance(uint256 tokenId) public view returns (uint256){
      return totalDividend - lastDividendAt[tokenId];
  }

  function splitBalance(uint256 amount) private {
      uint256 reflectionShare = amount/20;
      uint256 mintingShare  = amount - reflectionShare;
      reflectDividend(reflectionShare);
      payable(_admin).transfer(mintingShare);
  }

  function reflectDividend(uint256 amount) private {
    reflectionBalance  = reflectionBalance + amount;
    totalDividend = totalDividend + (amount/totalSupply());
  }
}
