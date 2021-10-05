# nft-mix
This is a repo to work with and use NFTs smart contracts in a python environment, using the Chainlink-mix as a starting point
### Compile
```
brownie compile
```
### Deploy
```
brownie run scripts/advanced_collectible/deploy_advanced.py
brownie run scripts/advanced_collectible/deploy_advanced.py --network rinkeby
```
### Scripts
```
brownie run scripts/advanced_collectible/create_collectible.py --network rinkeby
brownie run scripts/advanced_collectible/create_metadata.py --network rinkeby
brownie run scripts/advanced_collectible/set_tokenuri.py --network rinkeby
```