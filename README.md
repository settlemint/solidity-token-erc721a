<p align="center">
  <img src="https://github.com/settlemint/solidity-token-erc721a/blob/main/OG_Solidity.jpg" align="center" alt="logo" />
  <p align="center">
    ✨ <a href="https://settlemint.com">https://settlemint.com</a> ✨
    <br/>
    Build your own blockchain usecase with ease.
  </p>
</p>
<br/>
<p align="center">
<a href="https://github.com/settlemint/solidity-token-erc721a/actions?query=branch%3Amain"><img src="https://github.com/settlemint/solidity-token-erc721a/actions/workflows/solidity.yml/badge.svg?event=push&branch=main" alt="CI status" /></a>
<a href="https://fsl.software" rel="nofollow"><img src="https://img.shields.io/npm/l/@settlemint/solidity-token-erc721a" alt="License"></a>
<a href="https://www.npmjs.com/package/@settlemint/solidity-token-erc721a" rel="nofollow"><img src="https://img.shields.io/npm/dw/@settlemint/solidity-token-erc721a" alt="npm"></a>
<a href="https://github.com/settlemint/solidity-token-erc721a" rel="nofollow"><img src="https://img.shields.io/github/stars/settlemint/solidity-token-erc721a" alt="stars"></a>
</p>

<div align="center">
  <a href="https://console.settlemint.com/documentation/">Documentation</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://discord.com/invite/Mt5yqFrey9">Discord</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://www.npmjs.com/package/@settlemint/solidity-token-erc721a">NPM</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://github.com/settlemint/solidity-token-erc721a/issues">Issues</a>
  <br />
</div>

## Get Started

This repository provides a feature-rich ERC721A token contract, designed for efficient minting and NFT management. You can either:

- **Launch this smart contract set directly in SettleMint**: Under the `Smart Contract Sets` section. This will automatically link the contract to your blockchain node and use the private keys stored in the platform.
  
  For detailed instructions on deploying smart contracts using SettleMint, refer to this [deployment guide](https://console.settlemint.com/documentation/docs/using-platform/add_smart_contract_sets/deploying_a_contract/).

- **Integrate it into your own project**:
  - Bootstrap a new project using Forge:
    ```shell
    forge init my-project --template settlemint/solidity-token-erc721a
    ```
  - Or, add it as a dependency to your existing project using npm:
    ```shell
    npm install @settlemint/solidity-token-erc721a
    ```

### Deploy Contracts & Run Tasks in your Integrated IDE

Using SettleMint’s Integrated IDE, you can easily run tasks like compiling, testing, and deploying your contracts. Here’s how to get started:

1. Open the Tasks panel by pressing `Cmd + Shift + P` (Mac) or `Ctrl + Shift + P` (Windows/Linux) or by selecting it from the left menu.
2. Select the desired task from the list. Available tasks include:

   - **Foundry - Compile**: Compiles the Foundry contracts.
   - **Hardhat - Compile**: Compiles the Hardhat contracts.
   - **Foundry - Test**: Runs tests using Foundry.
   - **Hardhat - Test**: Runs tests using Hardhat.
   - **Foundry - Start Network**: Starts a local Ethereum network using Foundry.
   - **Hardhat - Start Network**: Starts a local Ethereum network using Hardhat.
   - **Hardhat - Deploy to Local Network**: Deploys contracts to a local network.
   - **Hardhat - Deploy to Platform Network**: Deploys contracts to the specified platform network.
   - **The Graph - Build & Deploy**: Builds and deploys the subgraph.

Alternatively, you can use the IDE terminal to deploy your contract using common commands from [Hardhat](https://hardhat.org/ignition/docs/guides/deploy) or [Foundry](https://book.getfoundry.sh/forge/deploying).

### Learn More about Foundry and Hardhat

To fully leverage the capabilities of Foundry and Hardhat, you can explore our comprehensive documentation [here](https://console.settlemint.com/documentation/docs/using-platform/add_smart_contract_sets/smart_contracts/).

## ERC721A Contract Features

This repository includes a customizable ERC721A token contract with the following features, designed for efficient and scalable NFT minting:

- **Efficient Minting**: ERC721A is optimized for gas efficiency, especially for batch minting operations.
- **Whitelist Support**: Implements a whitelist using Merkle proofs to manage pre-approved addresses during the minting process.
- **Royalty Support**: Integrates ERC2981 for royalty payments, allowing creators to earn a percentage on secondary sales.
- **Pausable Minting**: The contract owner can control the start and stop of public sales and whitelist sales.
- **Reentrancy Guard**: Protects against reentrancy attacks during the minting and withdrawal processes.

### Key Functions

- **`setBaseURI(string memory baseTokenURI_)`**: Sets the base URI for the token metadata.
- **`collectReserves()`**: Mints a reserved number of tokens for the team or future sale.
- **`gift(address[] calldata recipients_)`**: Mints tokens as gifts to specified addresses.
- **`setWhitelistMerkleRoot(bytes32 whitelistMerkleRoot_)`**: Sets the Merkle root for the whitelist.
- **`disableWhitelistMerkleRoot()`**: Disables the whitelist, transitioning to a public sale.
- **`whitelistMint(uint256 count, uint256 allowance, bytes32[] calldata proof)`**: Allows whitelisted addresses to mint tokens during the whitelist sale.
- **`publicMint(uint256 count)`**: Allows public minting of tokens when the public sale is active.
- **`withdraw()`**: Withdraws the contract’s balance to the designated wallet.

### OpenZeppelin Libraries and Custom Extensions Utilized

This contract leverages the following libraries and custom extensions:

- **ERC721A**: An optimized implementation of the ERC721 standard, designed for more efficient minting.
- **ERC2981**: Supports the ERC2981 standard for royalty payments on secondary sales.
- **Ownable**: Manages ownership, restricting access to critical functions.
- **ReentrancyGuard**: Prevents reentrancy attacks during critical operations.
- **ERC721Whitelist**: Custom extension to manage a whitelist of addresses using Merkle proofs.

## Documentation

- Additional documentation can be found in the [docs folder](./docs).
- [SettleMint Documentation](https://console.settlemint.com/documentation/docs/using-platform/integrated-development-environment/)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [Hardhat Documentation](https://hardhat.org/hardhat-runner/docs/getting-started)


