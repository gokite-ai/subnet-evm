# Kite Subnet-EVM Genesis Templates

This directory provides reference genesis configurations for bootstrapping local and testnet Kite Subnet EVM chains.

## Templates Available

1. **`kite-testnet-genesis.json`**:
   - **Chain ID**: `2368` (`0x940`)
   - **Gas Limit**: 20,000,000
   - **Target Block Rate**: 2 seconds
   - Optimized for testnet deployments and dApp testing.

2. **`kite-mainnet-genesis.json`**:
   - **Chain ID**: `2366` (`0x93E`)
   - **Gas Limit**: 25,000,000
   - **Target Block Rate**: 2 seconds
   - Matches production Kite mainnet execution specifications.

## Usage with Avalanche-CLI

Deploy a local Kite subnet instance:

```bash
# Create custom subnet using the testnet template
avalanche subnet create kiteDevnet --custom --genesis ./examples/kite-testnet-genesis.json

# Deploy to local network
avalanche subnet deploy kiteDevnet --local
```
