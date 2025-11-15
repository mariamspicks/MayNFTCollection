// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {MayNFTCollection} from "../src/MayNFTCollection.sol";

contract DeployScript is Script {
     function run() external {
        // Load deployment parameters from environment or use defaults
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Collection parameters
        string memory name = vm.envOr("NFT_NAME", string("My NFT Collection"));
        string memory symbol = vm.envOr("NFT_SYMBOL", string("MNFT"));
        uint256 maxSupply = vm.envOr("MAX_SUPPLY", uint256(100));
        uint256 mintPrice = vm.envOr("MINT_PRICE", uint256(0.01 ether));
        uint256 maxPerWallet = vm.envOr("MAX_PER_WALLET", uint256(5));
        string memory baseURI = vm.envOr("BASE_URI", string("ipfs://QmYourCID/"));
        
        vm.startBroadcast(deployerPrivateKey);
        
        MayNFTCollection nft = new MayNFTCollection(
            name,
            symbol,
            maxSupply,
            mintPrice,
            maxPerWallet,
            baseURI
        );
        
        vm.stopBroadcast();
        
        console.log("NFT Collection deployed to:", address(nft));
        console.log("Name:", name);
        console.log("Symbol:", symbol);
        console.log("Max Supply:", maxSupply);
        console.log("Mint Price:", mintPrice);
        console.log("Max Per Wallet:", maxPerWallet);
        console.log("Base URI:", baseURI);
    }
}

contract DeployAnvilScript is Script {
    function run() external {
        // Use default Anvil account
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        
        vm.startBroadcast(deployerPrivateKey);
        
        MayNFTCollection nft = new MayNFTCollection(
            "Anvil NFT Collection",
            "ANFT",
            100,
            0.01 ether,
            5,
            "ipfs://QmTestCID/"
        );
        
        vm.stopBroadcast();
        
        console.log("NFT Collection deployed to Anvil:", address(nft));
    }
}

contract DeploySepoliaScript is Script {
    function run() external returns (MayNFTCollection) {
        vm.startBroadcast();

        MayNFTCollection nft = new MayNFTCollection(
            "May NFT Collection",
            "MNFT",
            100,                    // maxSupply
            0.01 ether,            // mintPrice
            5,                     // maxPerWallet
            "ipfs://QmYourCID/"    // baseURI - update with actual IPFS CID later
        );

        // Enable minting
        nft.unpauseMinting();

        vm.stopBroadcast();

        console.log("================================");
        console.log("May NFT Collection deployed to Sepolia!");
        console.log("Contract Address:", address(nft));
        console.log("Name: May NFT Collection");
        console.log("Symbol: MNFT");
        console.log("Max Supply: 100");
        console.log("Mint Price: 0.01 ETH");
        console.log("Max Per Wallet: 5");
        console.log("Minting: ENABLED");
        console.log("================================");
        
        return nft;
    }
}