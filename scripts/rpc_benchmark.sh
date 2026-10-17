#!/usr/bin/env bash
# Kite Subnet EVM RPC Benchmark Harness
set -euo pipefail

RPC_URL="${1:-http://127.0.0.1:9650/ext/bc/2368/rpc}"
ITERATIONS="${2:-10}"

echo "============================================="
echo "Kite Subnet EVM RPC Benchmark"
echo "Target Endpoint: $RPC_URL"
echo "Iterations: $ITERATIONS"
echo "============================================="

measure_call() {
  local method="$1"
  local params="$2"
  curl -s -o /dev/null -w "%{time_total}\n" \
    -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"'"$method"'","params":'"$params"',"id":1}' \
    "$RPC_URL"
}

echo "Testing basic methods..."
measure_call "eth_blockNumber" "[]"
measure_call "eth_chainId" "[]"
