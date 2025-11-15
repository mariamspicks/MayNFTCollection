// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract MayNFTCollection is ERC721, ERC721Enumerable, Ownable {
    using Strings for uint256;

    uint256 public maxSupply;
    uint256 public mintPrice;
    uint256 public maxPerWallet;

    uint256 private _tokenIdCounter;
    string private baseTokenURI;
    string private notRevealedURI;
    bool public revealed;
    bool public mintingPaused;

    mapping(address => uint256) public mintedPerWallet;

     // Events 
    event NFTMinted(address indexed minter, uint256 indexed tokenId, uint256 timestamp);
    event MintPriceUpdated(uint256 oldPrice, uint256 newPrice);
    event MaxPerWalletUpdated(uint256 oldMax, uint256 newMax);
    event BaseURIUpdated(string newBaseURI);
    event MintingPaused(bool isPaused);
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event Revealed();
    

    // Errors 
    error MintingIsPaused();
    error MaxSupplyReached();
    error InsufficientPayment();
    error MaxPerWalletExceeded();
    error WithdrawalFailed();
    error InvalidParameter();

       constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        uint256 _mintPrice,
        uint256 _maxPerWallet,
        string memory __baseURI
    ) ERC721(_name, _symbol) Ownable(msg.sender) {
        if (_maxSupply == 0 || _maxPerWallet == 0) revert InvalidParameter();
        
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        maxPerWallet = _maxPerWallet;
        baseTokenURI = __baseURI;
        mintingPaused = false;
        revealed = false;
        _tokenIdCounter = 1;
    }
    

     // PUBLIC MINTING FUNCTIONS

     // Mint a single NFT
     // Mints one NFT to the caller's address
    function mint() external payable {
        _mintInternal(msg.sender, 1);
    }    

     // Mint multiple NFTs in one transaction
     // Mints specified quantity of NFTs to the caller's address   
    function mintBatch(uint256 quantity) external payable {
        if (quantity == 0) revert InvalidParameter();
        _mintInternal(msg.sender, quantity);
    }    

    function _mintInternal(address to, uint256 quantity) private {
        // Check if minting is paused
        if (mintingPaused) revert MintingIsPaused();
        
        // Check if max supply would be exceeded
        if (_tokenIdCounter + quantity - 1 > maxSupply) revert MaxSupplyReached();
        
        // Check if payment is sufficient
        if (msg.value < mintPrice * quantity) revert InsufficientPayment();
        
        // Check per-wallet limit
        if (mintedPerWallet[to] + quantity > maxPerWallet) revert MaxPerWalletExceeded();
        
        // Update minted count for wallet
        mintedPerWallet[to] += quantity;
        
        // Mint NFTs
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _tokenIdCounter;
            _tokenIdCounter++;
            _safeMint(to, tokenId);
            emit NFTMinted(to, tokenId, block.timestamp);
        }
    }

     //  OWNER FUNCTION 
    
     // Update the mint price
     // Only owner can update the mint price
     // New mint price in wei
    function setMintPrice(uint256 _newPrice) external onlyOwner {
        uint256 oldPrice = mintPrice;
        mintPrice = _newPrice;
        emit MintPriceUpdated(oldPrice, _newPrice);
    }    
    
     // Update the maximum NFTs per wallet
     // owner can update this limit
     //New maximum per wallet
    function setMaxPerWallet(uint256 _newMax) external onlyOwner {
        if (_newMax == 0) revert InvalidParameter();
        uint256 oldMax = maxPerWallet;
        maxPerWallet = _newMax;
        emit MaxPerWalletUpdated(oldMax, _newMax);
    }

    // Update the base URI for token metadata
    // Only owner can update the base URI
    // New base URI string
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseTokenURI = _newBaseURI;
        emit BaseURIUpdated(_newBaseURI);
    }

    // Only owner can pause/unpause minting
    // Only owner can withdraw funds from minting
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner()).call{value: balance}("");
        if (!success) revert WithdrawalFailed();
        emit FundsWithdrawn(owner(), balance);
    }    

    // Owner can mint NFTs for free (for giveaways, etc.)
    // Only owner can use this function
    function ownerMint(address to, uint256 quantity) external onlyOwner {
        if (quantity == 0) revert InvalidParameter();
        if (_tokenIdCounter + quantity - 1 > maxSupply) revert MaxSupplyReached();
        
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _tokenIdCounter;
            _tokenIdCounter++;
            _safeMint(to, tokenId);
            emit NFTMinted(to, tokenId, block.timestamp);
        }
    }

    // Owner controls for pausing minting
    function setMintingPaused(bool _paused) external onlyOwner {
        mintingPaused = _paused;
        emit MintingPaused(_paused);
    }

    function pauseMinting() external onlyOwner {
        mintingPaused = true;
        emit MintingPaused(true);
    }

    function unpauseMinting() external onlyOwner {
        mintingPaused = false;
        emit MintingPaused(false);
    }

    
    //  METADATA FUNCTION
    
    // Get the metadata URI for a specific token
    // Returns the complete URI by combining base URI with token ID
    // tokenId The ID of the token
    // Complete metadata URI for the token
    function tokenURI(uint256 tokenId) 
        public 
        view 
        override 
        returns (string memory) 
    {
        _requireOwned(tokenId);
        
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 
            ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
            : "";
    }

    // Base URI for computing tokenURI
    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }    


    //  VIEW FUNCTIONS 
    
    // Get the current total supply of minted NFTs
    // Current number of minted NFTs
    function getCurrentSupply() external view returns (uint256) {
        return _tokenIdCounter - 1;
    }
    
    function tokensOfOwner(address owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](tokenCount);
        
        for (uint256 i = 0; i < tokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }
        
        return tokenIds;
    }


       // Required overrides
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}  