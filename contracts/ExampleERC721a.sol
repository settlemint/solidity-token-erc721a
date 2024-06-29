// SPDX-License-Identifier: MIT
// SettleMint.com

pragma solidity ^0.8.24;

import { IERC721A, ERC721A } from "erc721a/contracts/ERC721A.sol";
import { ERC2981 } from "@openzeppelin/contracts/token/common/ERC2981.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import { ERC721Whitelist } from "./extensions/ERC721Whitelist.sol";

contract ExampleERC721a is ERC721A, ERC721Whitelist, Ownable, ReentrancyGuard {
    //////////////////////////////////////////////////////////////////
    // CONFIGURATION                                                //
    //////////////////////////////////////////////////////////////////

    uint256 public constant RESERVES = 5; // amount of tokens for the team, or to sell afterwards
    uint256 public constant PRICE_IN_WEI_WHITELIST = 0.0069 ether; // price per token in the whitelist sale
    uint256 public constant PRICE_IN_WEI_PUBLIC = 0.042 ether; // price per token in the public sale
    uint256 public constant MAX_PER_TX = 5; // maximum amount of tokens one can mint in one transaction
    uint256 public constant MAX_SUPPLY = 111; // the total amount of tokens for this NFT

    //////////////////////////////////////////////////////////////////
    // TOKEN STORAGE                                                //
    //////////////////////////////////////////////////////////////////

    string private _baseTokenURI; // the IPFS url to the folder holding the metadata.

    //////////////////////////////////////////////////////////////////
    // CROWDSALE STORAGE                                            //
    //////////////////////////////////////////////////////////////////

    address payable private immutable _wallet; // adress of the wallet which received the funds
    mapping(address => uint256) private _addressToMinted; // the amount of tokens an address has minted
    bool private _publicSaleOpen = false; // is the public sale open?

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseTokenURI_,
        address payable wallet_
    )
        ERC721A(name_, symbol_)
        Ownable(msg.sender)
    {
        _baseTokenURI = baseTokenURI_;
        _wallet = wallet_;
    }

    //////////////////////////////////////////////////////////////////
    // CORE FUNCTIONS                                               //
    //////////////////////////////////////////////////////////////////

    function setBaseURI(string memory baseTokenURI_) public onlyOwner {
        _baseTokenURI = baseTokenURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string memory tokenUri = super.tokenURI(tokenId);
        return bytes(tokenUri).length > 0 ? string(abi.encodePacked(tokenUri, ".json")) : "";
    }

    //////////////////////////////////////////////////////////////////
    // RESERVE TOKENS                                               //
    //////////////////////////////////////////////////////////////////

    function collectReserves() public onlyOwner {
        require(_totalMinted() == 0, "Reserves already collected");
        _safeMint(_wallet, RESERVES);
    }

    function gift(address[] calldata recipients_) external onlyOwner {
        require(_totalMinted() > 0, "Reserves not taken yet");
        uint256 recipients = recipients_.length;
        require(_totalMinted() + recipients <= MAX_SUPPLY, "Excedes max supply");
        for (uint256 i = 0; i < recipients; i++) {
            _safeMint(recipients_[i], 1);
        }
    }

    //////////////////////////////////////////////////////////////////
    // WHITELIST SALE                                               //
    //////////////////////////////////////////////////////////////////

    function setWhitelistMerkleRoot(bytes32 whitelistMerkleRoot_) external onlyOwner {
        _setWhitelistMerkleRoot(whitelistMerkleRoot_);
    }

    function whitelistMint(uint256 count, uint256 allowance, bytes32[] calldata proof) public payable nonReentrant {
        require(_totalMinted() > 0, "Reserves not taken yet");
        require(_totalMinted() + count <= MAX_SUPPLY, "Exceeds max supply");
        require(_validateWhitelistMerkleProof(allowance, proof), "Invalid Merkle Tree proof supplied");
        require(_addressToMinted[_msgSender()] + count <= allowance, "Exceeds whitelist allowance");
        require(count * PRICE_IN_WEI_WHITELIST == msg.value, "Invalid funds provided");
        _addressToMinted[_msgSender()] += count;
        _safeMint(_msgSender(), count);
    }

    //////////////////////////////////////////////////////////////////
    // PUBLIC SALE                                                  //
    //////////////////////////////////////////////////////////////////

    function startPublicSale() external onlyOwner {
        _disableWhitelistMerkleRoot();
        _publicSaleOpen = true;
    }

    function publicMint(uint256 count) public payable nonReentrant {
        require(_whiteListMerkleRoot == 0, "Public sale not active");
        require(_publicSaleOpen, "Public sale not active");
        require(_totalMinted() > 0, "Reserves not taken yet");
        require(_totalMinted() + count <= MAX_SUPPLY, "Exceeds max supply");
        require(count < MAX_PER_TX, "Exceeds max per transaction");
        require(count * PRICE_IN_WEI_PUBLIC == msg.value, "Invalid funds provided");
        _safeMint(_msgSender(), count);
    }

    //////////////////////////////////////////////////////////////////
    // POST SALE MANAGEMENT                                         //
    //////////////////////////////////////////////////////////////////

    function withdraw() public onlyOwner {
        _wallet.transfer(address(this).balance);
    }

    function wallet() public view returns (address) {
        return _wallet;
    }

    /*function burn(uint256 tokenId) public {
        _burn(tokenId);
    }*/

    //////////////////////////////////////////////////////////////////
    // ERC165                                                       //
    //////////////////////////////////////////////////////////////////

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
        return interfaceId == type(Ownable).interfaceId || interfaceId == type(IERC721A).interfaceId
            || interfaceId == type(ERC721Whitelist).interfaceId || ERC721A.supportsInterface(interfaceId)
            || interfaceId == type(ERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}
