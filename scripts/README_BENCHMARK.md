# Kite Subnet EVM RPC Benchmark Tool

A lightweight latency and concurrency testing script for Avalanche Subnet-EVM and Kite AI blockchain RPC endpoints.

## Features
- Latency probing for standard EVM JSON-RPC calls (`eth_blockNumber`, `eth_chainId`, `eth_gasPrice`, `eth_getBlockByNumber`).
- Configurable iterations and concurrent worker threads.
- Calculates Min, Average, Max, and 95th Percentile (p95) response times in milliseconds.
- Pure POSIX-compliant Bash using `curl` and `awk` without external heavyweight dependencies.

## Usage

```bash
# Grant execution permissions
chmod +x scripts/rpc_benchmark.sh

# Run with defaults against local Kite node (http://127.0.0.1:9650/ext/bc/2368/rpc, 30 iterations)
./scripts/rpc_benchmark.sh

# Custom RPC endpoint, 50 requests, 10 concurrency
./scripts/rpc_benchmark.sh https://rpc-testnet.kitescan.ai 50 10
```

## Sample Benchmark Output

```
| Method                 |         Min |         Avg |         Max |         p95 |
|------------------------|-------------|-------------|-------------|-------------|
| eth_blockNumber        |    14.20 ms |    18.45 ms |    45.10 ms |    23.50 ms |
| eth_chainId            |    12.80 ms |    16.12 ms |    38.40 ms |    19.90 ms |
| eth_gasPrice           |    15.30 ms |    19.80 ms |    52.20 ms |    25.10 ms |
| eth_getBlockLatest     |    22.40 ms |    29.75 ms |    78.60 ms |    39.20 ms |
```
