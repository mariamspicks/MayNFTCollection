# May NFT Collection 

An ERC-721 NFT collection with public minting functionality, deployed and verified on Ethereum Sepolia testnet. This project demonstrates secure smart contract development, comprehensive testing, gas optimization, and professional deployment practices.

## Table of Contents
- [Project Overview](#project-overview)
- [Live Deployment](#live-deployment)
- [Features](#features)
- [Technical Stack](#technical-stack)
- [Smart Contract Details](#smart-contract-details)
- [Testing & Coverage](#testing--coverage)
- [Installation & Setup](#installation--setup)
- [Deployment](#deployment)
- [Frontend Usage](#frontend-usage)
- [Metadata & IPFS](#metadata--ipfs)
- [Project Structure](#project-structure)
- [Security Considerations](#security-considerations)
- [Gas Optimization](#gas-optimization)
- [Future Improvements](#future-improvements)
- [License](#license)

---

## Project Overview

May NFT Collection is a fully functional ERC-721 NFT smart contract that allows public minting with configurable parameters. The project features AI-generated digital coin artwork stored on IPFS, with a fully functional smart contract and user-friendly minting interface.

**Collection Concept:** A limited edition digital art collection showcasing modern smart contract development practices, designed as an educational project to demonstrate mastery of Web3 fundamentals.

### Key Highlights
- **100% Test Pass Rate** - 33 comprehensive tests
- **72.82% Code Coverage** - Exceeds 70% requirement
- **Verified on Etherscan** - Full transparency
- **Gas Optimized** - Batch minting supported
- **Production Ready** - Deployed on Sepolia testnet and Anvil

---

## Live Deployment

### Sepolia Testnet (Main Deployment)
- **Network:** Ethereum Sepolia Testnet
- **Contract Address:** `0x8B94546b97104Dd16230bf5B70470cA1739eF209`
- **Etherscan (Verified):** [View on Etherscan](https://sepolia.etherscan.io/address/0x8b94546b97104dd16230bf5b70470ca1739ef209)
- **Status:** Live & Verified
- **Block Explorer:** Fully verified source code available

### Development Environment
- **Network:** Anvil Local Testnet
- **Contract Address:** `0x5FbDB2315678afecb367f032d93F642f64180aa3`
- **Purpose:** Local development and testing
- **Status:** Successfully tested with multiple mints

---

## Features

### Smart Contract Features
- **ERC-721 Standard Compliant**: Full OpenZeppelin implementation
- **Public Minting**: Anyone can mint NFTs by paying mint price
- **Configurable Parameters**:
    Mint Price: 0.01 ETH (adjustable by owner)
    Max Supply: 100 NFTs
    Max Per Wallet: 5 NFTs (adjustable by owner)
- **Unique Token IDs**: Sequential token ID generation
- **Token Metadata**: Dynamic tokenURI with IPFS integration
- **Enumerable**: Track all tokens and ownership

### Advanced Features
- **Batch Minting**: Mint multiple NFTs in one transaction
- **Pausable Minting**: Owner can pause/unpause minting
- **Per-Wallet Limits**: Maximum 5 NFTs per wallet
- **Owner Minting**: 
  Update mint price
  Update max per wallet
  Pause/unpause minting
  Update metadata base URI
  Free minting for giveaways
  Withdraw contract funds
- **Fund Withdrawal**: Secure withdrawal mechanism for owner
- **Event Emissions**: Comprehensive event logging

### Security Features
- **Access Control:** Owner-only functions properly secured
- **Input Validation:** All inputs validated with custom errors
- **Safe Transfers:** Using OpenZeppelin's safeMint
- **Overflow Protection:** Solidity 0.8+ built-in checks

### Frontend Features
- **Modern UI:** Beautiful gradient design with responsive layout
- **MetaMask Integration:** Seamless wallet connection
- **Real-time Stats:** Live display of collection metrics
- **Quantity Selection:** Mint multiple NFTs at once
- **Cost Calculator:** Automatic total cost calculation
- **Transaction Feedback:** Clear status messages and loading indicators
- **NFT Display:** View your minted tokens
- **Error Handling:** Comprehensive error messages

---

## Technical Stack

### Smart Contract Development
- **Language:** Solidity 0.8.30
- **Framework:** Foundry (Forge, Cast, Anvil)
- **Libraries:** OpenZeppelin Contracts v5.0
- **Testing:** Forge (Foundry's testing framework)
- **Standards:** ERC-721, ERC-721Enumerable

### Development Tools
- **Build Tool:** Forge
- **Coverage:** Forge coverage
- **Deployment:** Forge scripts
- **Local Blockchain:** Anvil
- **Verification:** Etherscan API integration

### Frontend
- **HTML5/CSS3** - Responsive design
- **JavaScript (ES6+)** - Modern async/await patterns
- **Ethers.js v6** - Web3 interaction library
- **Metadata Storage**: IPFS (via Pinata)
- **MetaMask** - Wallet integration

---

## Smart Contract Details

### Collection Parameters
| Parameter | Value | Description |
|-----------|-------|-------------|
| Name | May NFT Collection | Full collection name |
| Symbol | MNFT | Token symbol |
| Max Supply | 100 | Maximum total NFTs |
| Mint Price | 0.01 ETH | Cost per NFT |
| Max Per Wallet | 5 | Maximum per address |
| Initial State | Minting Enabled | Ready to mint |

### Contract Functions

#### Public Functions
```solidity
// Mint a single NFT
function mint() external payable

// Mint multiple NFTs in one transaction
function mintBatch(uint256 quantity) external payable

// Get token metadata URI
function tokenURI(uint256 tokenId) external view returns (string)

// Get all tokens owned by address
function tokensOfOwner(address owner) external view returns (uint256[])

// Get current minted supply
function getCurrentSupply() external view returns (uint256)
```

#### Owner Functions
```solidity
// Update mint price (owner only)
function setMintPrice(uint256 newPrice) external onlyOwner

// Update max per wallet (owner only)
function setMaxPerWallet(uint256 newMax) external onlyOwner

// Update metadata base URI (owner only)
function setBaseURI(string memory newBaseURI) external onlyOwner

// Pause minting (owner only)
function pauseMinting() external onlyOwner

// Resume minting (owner only)
function unpauseMinting() external onlyOwner

// Free mint for giveaways (owner only)
function ownerMint(address to, uint256 quantity) external onlyOwner

// Withdraw contract funds (owner only)
function withdraw() external onlyOwner
```

### Custom Errors
Gas-efficient error handling:
- `MintingIsPaused()` - Minting is currently paused
- `MaxSupplyReached()` - No more NFTs available
- `InsufficientPayment()` - Payment is too low
- `MaxPerWalletExceeded()` - Wallet limit reached
- `WithdrawalFailed()` - Fund withdrawal failed
- `InvalidParameter()` - Invalid function parameter

---

## Testing & Coverage

### Test Results Summary
```
Total Tests:     33
Passed:          33 ✅
Failed:          0
Success Rate:    100%
```

### Coverage Report
```
╭──────────────────────────┬─────────────┬──────────────┬──────────────┬──────────────╮
│ File                     │ % Lines     │ % Statements │ % Branches   │ % Funcs      │
├──────────────────────────┼─────────────┼──────────────┼──────────────┼──────────────┤
│ MayNFTCollection.sol     │ 94.94%      │ 95.60%       │ 90.00%       │ 89.47%       │
│ Total (with scripts)     │ 72.82%      │ 71.31%       │ 90.00%       │ 80.95%       │
╰──────────────────────────┴─────────────┴──────────────┴──────────────┴──────────────╯
```

✅ **Exceeds 70% requirement** for all metrics

### Test Categories

#### Core Functionality Tests (10 tests)
- ✅ Constructor initialization
- ✅ Single NFT minting
- ✅ Batch minting (multiple NFTs)
- ✅ Multiple users minting
- ✅ Owner free minting
- ✅ Token transfers
- ✅ Token enumeration
- ✅ Total supply tracking
- ✅ Excess payment handling
- ✅ Pause/unpause functionality

#### Security & Validation Tests (15 tests)
- ✅ Insufficient payment rejection
- ✅ Max supply enforcement
- ✅ Max per wallet enforcement
- ✅ Minting when paused (should fail)
- ✅ Zero quantity rejection
- ✅ Owner-only access control
- ✅ Constructor parameter validation
- ✅ Unauthorized pause attempts
- ✅ Invalid parameter rejection
- ✅ Withdrawal access control
- ✅ Non-existent token URI
- ✅ Transfer limit independence
- ✅ Max supply in owner mint
- ✅ Zero quantity in owner mint
- ✅ Invalid max per wallet update

#### Metadata & View Tests (5 tests)
- ✅ Token URI generation
- ✅ Base URI updates
- ✅ Tokens of owner (empty)
- ✅ Tokens of owner (with NFTs)
- ✅ Total supply calculation

#### Gas Optimization Tests (3 tests)
- ✅ Single mint gas usage (~178,000 gas)
- ✅ Batch mint gas usage (~415,000 gas for 3 NFTs)
- ✅ Gas efficiency verification

### Running Tests
```bash
# Run all tests
forge test

# Run with verbosity
forge test -vv

# Run specific test
forge test --match-test testMint -vvvv

# Generate coverage report
forge coverage --report summary
```

---

## Installation & Setup

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- [Git](https://git-scm.com/) installed
- [Node.js](https://nodejs.org/) (optional, for frontend)
- MetaMask wallet extension

### Installation Steps

1. **Clone the Repository**
```bash
git clone https://github.com/mariamspicks/MayNFTCollection.git
cd MayNFTCollection
```

2. **Install Dependencies**
```bash
# Install Foundry dependencies
forge install

# Install OpenZeppelin contracts
forge install OpenZeppelin/openzeppelin-contracts
```

3. **Configure Environment**
```bash
# Create .env file
cp .env.example .env

# Edit .env with your credentials
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
PRIVATE_KEY=your_private_key_here
ETHERSCAN_API_KEY=your_etherscan_api_key

NFT_NAME="MetaCoin Collection"
NFT_SYMBOL="MCOIN"
MAX_SUPPLY=100
MINT_PRICE=10000000000000000  # 0.01 ETH in wei
MAX_PER_WALLET=5
BASE_URI="ipfs://bafybeicjzlrgvqdyp7xq7bau2gtxgupdhi2wuaegpx5nysyd4fhyvglgyu/"
```

4. **Build the Project**
```bash
# Compile contracts
forge build

# Run tests
forge test

# Check coverage
forge coverage
```

5. **Run Local Blockchain (Optional)**
```bash
# Start Anvil (local Ethereum node)
anvil

# In another terminal, deploy locally
forge script script/DeployScript.s.sol:DeployAnvilScript \
    --rpc-url http://localhost:8545 \
    --broadcast
```

---

## Deployment

### Local Deployment (Anvil)

1. **Start Anvil**
```bash
anvil
```

2. **Deploy Contract**
```bash
forge script script/DeployScript.s.sol:DeployAnvilScript \
    --rpc-url http://localhost:8545 \
    --broadcast
```

### Testnet Deployment (Sepolia)

1. **Get Sepolia Test ETH**
   - Visit [Sepolia Faucet](https://sepoliafaucet.com/)
   - Enter your wallet address
   - Receive free test ETH

2. **Configure Environment**
```bash
# Ensure .env has:
# SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_KEY
# PRIVATE_KEY=your_private_key
# ETHERSCAN_API_KEY=your_etherscan_key
```

3. **Deploy to Sepolia**
```bash
source .env

forge script script/DeployScript.s.sol:DeploySepoliaScript \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

### Deployed Contracts

**Anvil (Local Testnet)**

```
Network: Anvil Local
Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
Chain ID: 31337
RPC URL: http://localhost:8545
Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```

**Sepolia Testnet** (Optional)

```
Network: Sepolia
Contract Address: 0x8B94546b97104Dd16230bf5B70470cA1739eF209
Chain ID: 11155111
Block Explorer: https://sepolia.etherscan.io/address/0x8b94546b97104dd16230bf5b70470ca1739ef209
Status: Verified 
```

**Verification (Manual)**
If auto-verification fails:
```bash
forge verify-contract \
    0x8B94546b97104Dd16230bf5B70470cA1739eF209 \
    src/MayNFTCollection.sol:MayNFTCollection \
    --chain-id 11155111 \
    --etherscan-api-key $ETHERSCAN_API_KEY
```

---

## Frontend Usage

### **Setup Frontend**

**Step 1: Update Contract Address**

Open `frontend/index.html` and find line ~185:

```javascript
const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
```

Replace with your deployed contract address.

**Step 2: Start Local Server**

```bash
cd frontend
python3 -m http.server 8000
```

Or use any HTTP server:
```bash
npx serve
# or
php -S localhost:8000
```

**Step 3: Open in Browser**

Navigate to: `http://localhost:8000`

### **Configure MetaMask**

**For Anvil (Local Testing):**

1. **Add Network:**
   - Network Name: `Anvil Local`
   - RPC URL: `http://localhost:8545`
   - Chain ID: `31337`
   - Currency: `ETH`

2. **Import Test Account:**
   - Private Key: `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`
   - You'll see ~10,000 ETH

**For Sepolia Testnet:**

### Option 1: Web Interface (Recommended)

1. **Configure MetaMask**
   - Switch to Sepolia network
   - Ensure you have Sepolia test ETH

2. **Mint NFT**
   - Click "Connect MetaMask"
   - Select quantity (1-5)
   - Click "Mint NFT"
   - Confirm transaction in MetaMask
   - Wait for confirmation

### Option 2: Etherscan (Direct)

1. **Visit Contract**
   - Go to [Contract on Etherscan](https://sepolia.etherscan.io/address/0x8b94546b97104dd16230bf5b70470ca1739ef209#writeContract)

2. **Connect Wallet**
   - Click "Connect to Web3"
   - Connect MetaMask

3. **Mint Function**
   - Find `mint()` function
   - Enter payableAmount: `0.01` ETH
   - Click "Write"
   - Confirm in MetaMask

### Option 3: Command Line (Cast)

```bash
# Set contract address
CONTRACT=0x8B94546b97104Dd16230bf5B70470cA1739eF209

# Mint single NFT
cast send $CONTRACT "mint()" \
    --value 0.01ether \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY

# Mint multiple NFTs (batch)
cast send $CONTRACT "mintBatch(uint256)" 3 \
    --value 0.03ether \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY

# Check your balance
cast call $CONTRACT "balanceOf(address)(uint256)" YOUR_ADDRESS \
    --rpc-url $SEPOLIA_RPC_URL
```

### Minting Rules
- **Price:** 0.01 ETH per NFT
- **Max Per Transaction:** No limit (gas permitting)
- **Max Per Wallet:** 5 NFTs total
- **Total Supply:** 100 NFTs
- **Payment:** Must send exact or more ETH (excess refunded)

---

## Metadata & IPFS

### **Metadata Structure**

Each NFT has a JSON metadata file following OpenSea standards:

```json
{
  "name": "MetaCoin Collection #1",
  "description": "A unique collectible coin from the Genesis collection featuring circuit board design and metallic finish",
  "image": "ipfs://bafybeifuccmwzkpcfwojwnirosdf27uamnbnwjjaujrn4cg2s6stjuhezm/1.png",
  "attributes": [
    {
      "trait_type": "Background colour",
      "value": "pink"
    },
    {
      "trait_type": "Background colour",
      "value": "pink"
    },
    {
      "trait_type": "Background colour",
      "value": "Pink"
    },
    {
      "trait_type": "Background colour",
      "value": "pink"
    },
    {
      "trait_type": "Background colour",
      "value": "pink"
    }
  ]
}
```

### **IPFS Storage Details**

**Images CID:** `bafybeifuccmwzkpcfwojwnirosdf27uamnbnwjjaujrn4cg2s6stjuhezm`
- Contains: 1.png, 2.png, 3.png, 4.png, 5.png
- Gateway: `https://ipfs.io/ipfs/bafybeifuccmwzkpcfwojwnirosdf27uamnbnwjjaujrn4cg2s6stjuhezm/`

**Metadata CID:** `bafybeicjzlrgvqdyp7xq7bau2gtxgupdhi2wuaegpx5nysyd4fhyvglgyu`
- Contains: 1.json, 2.json, 3.json, 4.json, 5.json
- Gateway: `https://ipfs.io/ipfs/bafybeicjzlrgvqdyp7xq7bau2gtxgupdhi2wuaegpx5nysyd4fhyvglgyu/`

**Contract BASE_URI:** `ipfs://bafybeicjzlrgvqdyp7xq7bau2gtxgupdhi2wuaegpx5nysyd4fhyvglgyu/`

### **Viewing Metadata**

**Via IPFS Gateway:**
```
https://ipfs.io/ipfs/bafybeicjzlrgvqdyp7xq7bau2gtxgupdhi2wuaegpx5nysyd4fhyvglgyu/1.json
```

**Via Contract:**
```bash
cast call <CONTRACT_ADDRESS> "tokenURI(uint256)" 1 --rpc-url <RPC_URL>
```

**Via OpenSea (Testnet):**
```
https://testnets.opensea.io/assets/sepolia/<CONTRACT_ADDRESS>/1
```

### **AI-Generated Artwork**

Our NFT collection features AI-generated digital coin artwork created with:
- **Tool:** Leonardo.ai / Bing Image Creator
- **Theme:** digital currency for May NFT
- **Resolution:** 512x512px PNG
- **Color Schemes:** Pink

## Project Structure

```
MayNFTCollection/
│
├── src/
│   └── MayNFTCollection.sol        # Main NFT smart contract (ERC-721)
│
├── test/
│   └── MayNFTCollection.t.sol      # Comprehensive test suite (33 tests)
│
├── script/
│   └── DeployScript.s.sol          # Deployment scripts (Anvil & Sepolia)
│
├── frontend/
│   └── index.html                  # Web minting interface
│
├── metadata/
│   ├── 1.json                       # NFT metadata files
│   ├── 2.json
│   ├── 3.json
│   ├── 4.json
│   └── 5.json
│
├── lib/
│   └── openzeppelin-contracts/     # OpenZeppelin dependencies
│
├── broadcast/                      # Deployment artifacts
├── cache/                          # Forge cache
├── out/                            # Compiled contracts
│
├── foundry.toml                    # Foundry configuration
├── .env.example                    # Environment template
├── .gitignore                      # Git ignore rules
├── README.md                       # This file
├── TESTING.md                      # Detailed test documentation
└── LICENSE                         # MIT License

```

### Key Files

#### Smart Contracts
- `src/MayNFTCollection.sol` - Main NFT contract with all logic
- Inherits: ERC721, ERC721Enumerable, Ownable

#### Tests
- `test/MayNFTCollection.t.sol` - Complete test suite
- Covers: minting, security, gas optimization, edge cases

#### Scripts
- `script/DeployScript.s.sol` - Deployment automation
- Supports: Anvil (local) and Sepolia (testnet)

#### Frontend
- `frontend/index.html` - Single-page minting application
- Features: MetaMask integration, real-time updates, NFT display

---

## Security Considerations

### Implemented Security Measures

1. **Access Control**
   - Ownable pattern for privileged functions
   - Only owner can: pause, change price, withdraw, etc.

2. **Input Validation**
   - All inputs checked with require statements
   - Custom errors for gas efficiency

3. **Integer Safety**
   - Solidity 0.8+ automatic overflow/underflow protection
   - Explicit checks for critical operations

4. **Safe Transfers**
   - Using `_safeMint()` instead of `_mint()`
   - Ensures receivers can handle NFTs

5. **Pausability**
   - Emergency stop mechanism
   - Owner can pause minting if issues arise

6. **Supply Limits**
   - Hard cap on total supply (100)
   - Per-wallet limits (5) prevent hoarding

7. **Payment Validation**
   - Exact payment verification
   - Prevents under-payment attacks

### Audit Recommendations
Before mainnet deployment, consider:
- Professional smart contract audit
- Bug bounty program
- Gradual rollout strategy
- Multi-signature wallet for owner
- Timelock for critical functions

### Known Limitations
- No built-in royalty mechanism (EIP-2981)
- No burning mechanism implemented
- No whitelist/allowlist functionality

---

## Gas Optimization

### Optimization Techniques Applied

1. **Batch Minting**
   - Mint multiple NFTs in one transaction
   - Amortizes gas cost across multiple NFTs

2. **Custom Errors**
   - Using custom errors instead of string messages
   - Saves ~50 gas per revert

3. **Storage Optimization**
   - Efficient variable packing
   - Minimized storage reads/writes

4. **Loop Optimization**
   - Cache array lengths
   - Efficient iteration patterns

5. **Function Modifiers**
   - View/pure functions where possible
   - Reduces unnecessary state access

### Gas Costs

| Operation | Gas Used | Notes |
|-----------|----------|-------|
| Single Mint | ~178,000 | First mint from wallet |
| Batch Mint (3) | ~415,000 | ~138k per NFT |
| Batch Mint (5) | ~665,000 | ~133k per NFT |
| Transfer | ~50,000 | Standard ERC-721 |
| Approval | ~45,000 | Standard ERC-721 |

**Batch Minting Efficiency:** Saves ~20% gas per NFT when minting multiple

---

## Future Improvements

### Planned Features
- [ ] Whitelist/Allowlist functionality
- [ ] Reveal mechanism for metadata
- [ ] EIP-2981 royalty support
- [ ] NFT burning capability
- [ ] Staking mechanism
- [ ] Airdrop functionality
- [ ] Dutch auction minting

### Technical Enhancements
- [ ] Multi-signature owner control
- [ ] Upgradeable proxy pattern
- [ ] Gas optimization V2
- [ ] Merkle tree whitelist
- [ ] Chainlink VRF for randomness
- [ ] Cross-chain bridge support

### Community Features
- [ ] Discord integration
- [ ] DAO governance
- [ ] Community treasury
- [ ] NFT utilities
- [ ] Holder benefits

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Mariam

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## Author

**Mariam**

- GitHub: [@mariamspicks](https://github.com/mariamspicks)
- Project: May NFT Collection
- Email: [ayomidet27@gmail.com]

---

## Acknowledgments

### Technologies & Libraries
- **OpenZeppelin** - Secure smart contract libraries
- **Foundry** - Blazing fast Ethereum development toolkit
- **Ethers.js** - Complete Ethereum library
- **Solidity** - Smart contract programming language

### Community & Resources
- Ethereum Foundation for the EVM
- Foundry Book for comprehensive documentation
- OpenZeppelin community for security best practices
- Web3 developers community for support and guidance

### Educational Resources
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts)
- [Ethereum.org](https://ethereum.org/en/developers/)

---

## Support & Contact

### Getting Help
- **Documentation:** Check this README and code comments
- **Issues:** Open an issue on [GitHub](https://github.com/mariamspicks/MayNFTCollection/issues)

### Useful Links
- **Repository:** https://github.com/mariamspicks/MayNFTCollection
- **Live Contract:** https://sepolia.etherscan.io/address/0x8b94546b97104dd16230bf5b70470ca1739ef209
- **Foundry Docs:** https://book.getfoundry.sh/
- **OpenZeppelin:** https://docs.openzeppelin.com/

---

## Version History

### v1.0.0 (Current)
- Initial release
- ERC-721 implementation
- Public minting with configurable parameters
- Comprehensive test suite
- Sepolia testnet deployment
- Etherscan verification
- Web minting interface

---

*May NFT Collection - Demonstrating Excellence in Web3 Development*

---

**If you find this project helpful, please give it a star on GitHub!**