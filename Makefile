# Makefile for Foundry Ethereum Development Toolkit

.PHONY: build test format snapshot anvil deploy deploy-anvil cast help subgraph

build:
	@echo "Building with Forge..."
	@forge build

test:
	@echo "Testing with Forge..."
	@forge test

format:
	@echo "Formatting with Forge..."
	@forge fmt

snapshot:
	@echo "Creating gas snapshot with Forge..."
	@forge snapshot

anvil:
	@echo "Starting Anvil local Ethereum node..."
	@anvil

deploy-anvil:
	@echo "Deploying with Forge to Anvil..."
	@forge create ./src/ExampleERC721a.sol:ExampleERC721a --rpc-url anvil --interactive --constructor-args "GenericTokenMeta" "GTM" "ipfs://bafybeifc23vyo52i6dtlba7u7kmbcpc5oxfcwjaz3oisagq3kq7i2dbo6q/"  "0x813af93e50F0bCD2BAaFfa7E4dD4710adC01dE7d" | tee deployment-anvil.txt

deploy-btp:
	@eval $$(curl -H "x-auth-token: $${BPT_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /'); \
	args=""; \
	@if [ ! -z "$${BTP_FROM}" ]; then \
		args="--unlocked --from $${BTP_FROM}"; \
	else \
		echo "\033[1;33mWARNING: No keys are activated on the node, falling back to interactive mode...\033[0m"; \
		echo ""; \
		args="--interactive"; \
	fi; \
	if [ ! -z "$${BTP_GAS_PRICE}" ]; then \
		args="$$args --gas-price $${BTP_GAS_PRICE}"; \
	fi; \
	if [ "$${BTP_EIP_1559_ENABLED}" = "false" ]; then \
		args="$$args --legacy"; \
	fi; \
	forge create ./src/ExampleERC721a.sol:ExampleERC721a ${EXTRA_ARGS} --rpc-url ${BTP_RPC_URL} $$args --constructor-args "GenericTokenMeta" "GTM" "ipfs://bafybeifc23vyo52i6dtlba7u7kmbcpc5oxfcwjaz3oisagq3kq7i2dbo6q/" "0x813af93e50F0bCD2BAaFfa7E4dD4710adC01dE7d" | tee deployment.txt;

cast:
	@echo "Interacting with EVM via Cast..."
	@cast $(SUBCOMMAND)

subgraph:
	@echo "Deploying the subgraph..."
	@rm -Rf subgraph/subgraph.config.json
	@DEPLOYED_ADDRESS=$$(grep "Deployed to:" deployment.txt | awk '{print $$3}') yq e -p=json -o=json '.datasources[0].address = env(DEPLOYED_ADDRESS) | .chain = env(BTP_NODE_UNIQUE_NAME)' subgraph/subgraph.config.template.json > subgraph/subgraph.config.json
	@cd subgraph && pnpm graph-compiler --config subgraph.config.json --include node_modules/@openzeppelin/subgraphs/src/datasources ./datasources --export-schema --export-subgraph
	@cd subgraph && yq e '.specVersion = "0.0.4"' -i generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && yq e '.description = "Solidity Token ERC721a"' -i generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && yq e '.repository = "https://github.com/settlemint/solidity-token-ERC721a"' -i generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && yq e '.indexerHints.prune = "auto"' -i generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && yq e '.features = ["nonFatalErrors", "fullTextSearch", "ipfsOnEthereumContracts"]' -i generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && npx graph codegen generated/solidity-token-ERC721a.subgraph.yaml
	@cd subgraph && npx graph build generated/solidity-token-ERC721a.subgraph.yaml
	@eval $$(curl -H "x-auth-token: $${BPT_SERVICE_TOKEN}" -s $${BTP_CLUSTER_MANAGER_URL}/ide/foundry/$${BTP_SCS_ID}/env | sed 's/^/export /')
	@if [ "$${BTP_MIDDLEWARE}" == "" ]; then \
		echo "\033[1;31mERROR: You have not launched a graph middleware for this smart contract set, aborting...\033[0m"; \
		exit 1; \
	else \
		cd subgraph; \
		npx graph create --node $${BTP_MIDDLEWARE} $${BTP_SCS_NAME}; \
		npx graph deploy --version-label v1.0.$$(date +%s) --node $${BTP_MIDDLEWARE} --ipfs $${BTP_IPFS}/api/v0 $${BTP_SCS_NAME} generated/solidity-token-ERC721a.subgraph.yaml; \
	fi

help:
	@echo "Forge help..."
	@forge --help
	@echo "Anvil help..."
	@anvil --help
	@echo "Cast help..."
	@cast --help
