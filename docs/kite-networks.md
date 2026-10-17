# Kite AI Subnet-EVM Network Specifications

This document defines the network parameters, chain IDs, and precompile capabilities for Kite AI subnets powered by Subnet-EVM.

## Network Parameters

| Parameter | Kite AI Testnet | Kite AI Mainnet |
|---|---|---|
| **EVM Chain ID** | `2368` (`0x940`) | `2366` (`0x93E`) |
| **CAIP-2 Identifier** | `eip155:2368` | `eip155:2366` |
| **Native Token** | KITE | KITE |
| **Settlement Asset** | pieUSD (18 decimals) | USDC.e (6 decimals) |
| **Public RPC** | `https://rpc-testnet.kitescan.ai` | `https://rpc.kitescan.ai` |
| **Block Explorer** | `https://testnet.kitescan.ai` | `https://kitescan.ai` |

## Precompile Allocations

Kite Subnet-EVM supports EVM precompiles for sub-cent micropayments, account abstraction, and facilitator settlement routing:

- **ExactEvmScheme**: Sub-cent stream validation
- **TxDenyList**: Optional operator transaction pool policy

---

## Local Subnet-EVM Runner Instructions

Operators and local developers can build and mount the Subnet-EVM binary into AvalancheGo:

### 1. Build Subnet-EVM Plugin
```bash
./scripts/build.sh build/subnet-evm
```

### 2. Install Plugin to AvalancheGo Directory
```bash
mkdir -p ~/.avalanchego/plugins
cp build/subnet-evm ~/.avalanchego/plugins/srEXiWaHuhNyGwPUi444Tu47ZEDwxTWrbQiuD7FmgSAQ6X7Dy
```

### 3. Verify RPC Connectivity
```bash
curl -s -X POST http://127.0.0.1:9650/ext/bc/C/rpc \
  -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```
