// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test} from "../lib/forge-std/src/Test.sol";
import {MayNFTCollection} from "../src/MayNFTCollection.sol";

contract MayNFTCollectionTest is Test {
    MayNFTCollection public nft;
    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);
    
    uint256 constant MAX_SUPPLY = 100;
    uint256 constant MINT_PRICE = 0.01 ether;
    uint256 constant MAX_PER_WALLET = 5;
    string constant BASE_URI = "ipfs://QmTest/";
    
    event NFTMinted(address indexed minter, uint256 indexed tokenId, uint256 timestamp);
    event MintPriceUpdated(uint256 oldPrice, uint256 newPrice);
    event MaxPerWalletUpdated(uint256 oldMax, uint256 newMax);
    event BaseURIUpdated(string newBaseURI);
    event MintingPaused(bool isPaused);
    event FundsWithdrawn(address indexed owner, uint256 amount);

    function setUp() public {
        vm.prank(owner);
        nft = new MayNFTCollection(
            "My NFT Collection",
            "MNFT",
            MAX_SUPPLY,
            MINT_PRICE,
            MAX_PER_WALLET,
            BASE_URI
        );
        
        // Fund test addresses
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    // ============ Constructor Tests ============
    
    function test_Constructor() public view {
        assertEq(nft.name(), "My NFT Collection");
        assertEq(nft.symbol(), "MNFT");
        assertEq(nft.maxSupply(), MAX_SUPPLY);
        assertEq(nft.mintPrice(), MINT_PRICE);
        assertEq(nft.maxPerWallet(), MAX_PER_WALLET);
        assertEq(nft.owner(), owner);
        assertFalse(nft.mintingPaused());
    }
    
    function test_RevertConstructorInvalidMaxSupply() public {
        vm.prank(owner);
        vm.expectRevert(MayNFTCollection.InvalidParameter.selector);
        new MayNFTCollection("Test", "TST", 0, MINT_PRICE, MAX_PER_WALLET, BASE_URI);
    }
    
    function test_RevertConstructorInvalidMaxPerWallet() public {
        vm.prank(owner);
        vm.expectRevert(MayNFTCollection.InvalidParameter.selector);
        new MayNFTCollection("Test", "TST", MAX_SUPPLY, MINT_PRICE, 0, BASE_URI);
    }

    // ============ Minting Tests ============
    
    function test_Mint() public {
        vm.prank(user1);
        vm.expectEmit(true, true, false, false);
        emit NFTMinted(user1, 1, block.timestamp);
        nft.mint{value: MINT_PRICE}();
        
        assertEq(nft.balanceOf(user1), 1);
        assertEq(nft.ownerOf(1), user1);
        assertEq(nft.getCurrentSupply(), 1);
        assertEq(nft.mintedPerWallet(user1), 1);
    }
    
    function test_MintBatch() public {
        uint256 quantity = 3;
        vm.prank(user1);
        nft.mintBatch{value: MINT_PRICE * quantity}(quantity);
        
        assertEq(nft.balanceOf(user1), quantity);
        assertEq(nft.getCurrentSupply(), quantity);
        assertEq(nft.mintedPerWallet(user1), quantity);
        
        // Verify all tokens are owned by user1
        for (uint256 i = 1; i <= quantity; i++) {
            assertEq(nft.ownerOf(i), user1);
        }
    }
    
    function test_MintMultipleUsers() public {
        vm.prank(user1);
        nft.mint{value: MINT_PRICE}();
        
        vm.prank(user2);
        nft.mint{value: MINT_PRICE}();
        
        assertEq(nft.balanceOf(user1), 1);
        assertEq(nft.balanceOf(user2), 1);
        assertEq(nft.getCurrentSupply(), 2);
    }
    
    function test_RevertMintInsufficientPayment() public {
        vm.prank(user1);
        vm.expectRevert(MayNFTCollection.InsufficientPayment.selector);
        nft.mint{value: MINT_PRICE - 1}();
    }
    
    function test_RevertMintBatchInsufficientPayment() public {
        vm.prank(user1);
        vm.expectRevert(MayNFTCollection.InsufficientPayment.selector);
        nft.mintBatch{value: MINT_PRICE * 2}(3);
    }
    
    function test_RevertMintBatchZeroQuantity() public {
        vm.prank(user1);
        vm.expectRevert(MayNFTCollection.InvalidParameter.selector);
        nft.mintBatch{value: 0}(0);
    }
    
    function test_RevertMintMaxPerWalletExceeded() public {
        vm.startPrank(user1);
        nft.mintBatch{value: MINT_PRICE * MAX_PER_WALLET}(MAX_PER_WALLET);
        
        vm.expectRevert(MayNFTCollection.MaxPerWalletExceeded.selector);
        nft.mint{value: MINT_PRICE}();
        vm.stopPrank();
    }
    
    function test_RevertMintMaxSupplyReached() public {
        // Create a small collection
        vm.prank(owner);
        MayNFTCollection smallNFT = new MayNFTCollection(
            "Small",
            "SML",
            5,
            MINT_PRICE,
            10,
            BASE_URI
        );
        
        // Mint all tokens
        vm.prank(user1);
        smallNFT.mintBatch{value: MINT_PRICE * 5}(5);
        
        // Try to mint one more
        vm.prank(user2);
        vm.expectRevert(MayNFTCollection.MaxSupplyReached.selector);
        smallNFT.mint{value: MINT_PRICE}();
    }
    
    function test_MintWithExcessPayment() public {
        uint256 excessPayment = MINT_PRICE * 2;
        
        vm.prank(user1);
        nft.mint{value: excessPayment}();
        
        assertEq(nft.balanceOf(user1), 1);
        assertEq(address(nft).balance, excessPayment);
    }

    // ============ Pause Tests ============
    
    function test_PauseMinting() public {
        vm.prank(owner);
        nft.setMintingPaused(true);
        assertTrue(nft.mintingPaused());
        
        vm.prank(user1);
        vm.expectRevert(MayNFTCollection.MintingIsPaused.selector);
        nft.mint{value: MINT_PRICE}();
    }
    
    function test_UnpauseMinting() public {
        vm.startPrank(owner);
        nft.pauseMinting();
        nft.unpauseMinting();
        vm.stopPrank();
        
        assertFalse(nft.mintingPaused());
        
        vm.prank(user1);
        nft.mint{value: MINT_PRICE}();
        assertEq(nft.balanceOf(user1), 1);
    }
    
    function test_RevertPauseMintingNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        nft.setMintingPaused(true);
    }

    // ============ Owner Functions Tests ============
    
    function test_SetMintPrice() public {
        uint256 newPrice = 0.02 ether;
        
        vm.prank(owner);
        vm.expectEmit(false, false, false, true);
        emit MintPriceUpdated(MINT_PRICE, newPrice);
        nft.setMintPrice(newPrice);
        
        assertEq(nft.mintPrice(), newPrice);
    }
    
    function test_SetMaxPerWallet() public {
        uint256 newMax = 10;
        
        vm.prank(owner);
        vm.expectEmit(false, false, false, true);
        emit MaxPerWalletUpdated(MAX_PER_WALLET, newMax);
        nft.setMaxPerWallet(newMax);
        
        assertEq(nft.maxPerWallet(), newMax);
    }
    
    function test_RevertSetMaxPerWalletZero() public {
        vm.prank(owner);
        vm.expectRevert(MayNFTCollection.InvalidParameter.selector);
        nft.setMaxPerWallet(0);
    }
    
    function test_SetBaseURI() public {
        string memory newURI = "ipfs://QmNewTest/";
        
        vm.prank(owner);
        vm.expectEmit(false, false, false, true);
        emit BaseURIUpdated(newURI);
        nft.setBaseURI(newURI);
        
        // Mint a token to test URI
        vm.prank(user1);
        nft.mint{value: MINT_PRICE}();
        
        string memory expectedURI = string(abi.encodePacked(newURI, "1.json"));
        assertEq(nft.tokenURI(1), expectedURI);
    }
    
    function test_OwnerMint() public {
        uint256 quantity = 3;
        
        vm.prank(owner);
        nft.ownerMint(user1, quantity);
        
        assertEq(nft.balanceOf(user1), quantity);
        assertEq(nft.getCurrentSupply(), quantity);
        // Owner mint doesn't count towards per-wallet limit
        assertEq(nft.mintedPerWallet(user1), 0);
    }
    
    function test_RevertOwnerMintMaxSupply() public {
        vm.prank(owner);
        vm.expectRevert(MayNFTCollection.MaxSupplyReached.selector);
        nft.ownerMint(user1, MAX_SUPPLY + 1);
    }
    
    function test_RevertOwnerMintZeroQuantity() public {
        vm.prank(owner);
        vm.expectRevert(MayNFTCollection.InvalidParameter.selector);
        nft.ownerMint(user1, 0);
    }
    
    function test_Withdraw() public {
        // Mint some NFTs to fund the contract
        vm.prank(user1);
        nft.mintBatch{value: MINT_PRICE * 3}(3);
        
        uint256 contractBalance = address(nft).balance;
        uint256 ownerBalanceBefore = address(owner).balance;
        
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit FundsWithdrawn(owner, contractBalance);
        nft.withdraw();
        
        assertEq(address(nft).balance, 0);
        assertEq(address(owner).balance, ownerBalanceBefore + contractBalance);
    }
    
    function test_RevertWithdrawNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OwnableUnauthorizedAccount(address)", user1));
        nft.withdraw();
    }

    // ============ Metadata Tests ============
    
    function test_TokenURI() public {
        vm.prank(user1);
        nft.mint{value: MINT_PRICE}();
        
        string memory expectedURI = string(abi.encodePacked(BASE_URI, "1.json"));
        assertEq(nft.tokenURI(1), expectedURI);
    }
    
    function test_RevertTokenURINonexistent() public {
        vm.expectRevert();
        nft.tokenURI(999);
    }

    // ============ Enumeration Tests ============
    
    function test_TokensOfOwner() public {
        uint256 quantity = 3;
        
        vm.prank(user1);
        nft.mintBatch{value: MINT_PRICE * quantity}(quantity);
        
        uint256[] memory tokens = nft.tokensOfOwner(user1);
        
        assertEq(tokens.length, quantity);
        assertEq(tokens[0], 1);
        assertEq(tokens[1], 2);
        assertEq(tokens[2], 3);
    }
    
    function test_TokensOfOwnerEmpty() public view {
        uint256[] memory tokens = nft.tokensOfOwner(user1);
        assertEq(tokens.length, 0);
    }
    
    function test_TotalSupply() public {
        vm.prank(user1);
        nft.mintBatch{value: MINT_PRICE * 3}(3);
        
        vm.prank(user2);
        nft.mintBatch{value: MINT_PRICE * 2}(2);
        
        assertEq(nft.totalSupply(), 5);
    }

    // ============ Transfer Tests ============
    
    function test_Transfer() public {
        vm.prank(user1);
        nft.mint{value: MINT_PRICE}();
        
        vm.prank(user1);
        nft.transferFrom(user1, user2, 1);
        
        assertEq(nft.ownerOf(1), user2);
        assertEq(nft.balanceOf(user1), 0);
        assertEq(nft.balanceOf(user2), 1);
    }
    
    function test_TransferDoesNotAffectMintLimit() public {
        // User1 mints max tokens
        vm.prank(user1);
        nft.mintBatch{value: MINT_PRICE * MAX_PER_WALLET}(MAX_PER_WALLET);
        
        // Transfer one to user2
        vm.prank(user1);
        nft.transferFrom(user1, user2, 1);
        
        // User1 still can't mint more (limit based on minted, not owned)
        vm.prank(user1);
        vm.expectRevert(MayNFTCollection.MaxPerWalletExceeded.selector);
        nft.mint{value: MINT_PRICE}();
    }

    // ============ Gas Optimization Tests ============
    
    function test_GasMintSingle() public {
        vm.prank(user1);
        uint256 gasBefore = gasleft();
        nft.mint{value: MINT_PRICE}();
        uint256 gasUsed = gasBefore - gasleft();
        
        // Log gas usage for reference
        emit log_named_uint("Gas used for single mint", gasUsed);
    }
    
    function test_GasMintBatch() public {
        vm.prank(user1);
        uint256 gasBefore = gasleft();
        nft.mintBatch{value: MINT_PRICE * 3}(3);
        uint256 gasUsed = gasBefore - gasleft();
        
        emit log_named_uint("Gas used for batch mint (3)", gasUsed);
    }
}