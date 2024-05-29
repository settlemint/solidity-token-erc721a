import { buildModule } from '@nomicfoundation/hardhat-ignition/modules';

const ExampleERC721aModule = buildModule('ExampleERC721aModule', (m) => {
  const erc721a = m.contract('ExampleERC721a', [
    'ExampleNFT',
    'NFT',
    'ipfs://',
    '0xa5409ec958C83C3f309868babACA7c86DCB077c1',
    '0x813af93e50F0bCD2BAaFfa7E4dD4710adC01dE7d',
  ]);
  return { erc721a };
});

export default ExampleERC721aModule;
