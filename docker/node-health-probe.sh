#!/usr/bin/env bash
# Container health and readiness probe for Kite Subnet-EVM
set -euo pipefail

RPC_HOST="${1:-http://localhost:9650}"
TIMEOUT="${2:-30}"

echo "Checking Subnet EVM node health at $RPC_HOST..."
start_time=$(date +%s)

while true; do
  current_time=$(date +%s)
  elapsed=$((current_time - start_time))

  if [ "$elapsed" -ge "$TIMEOUT" ]; then
    echo "ERROR: Health check timed out after ${TIMEOUT}s"
    exit 1
  fi

  # 1. Platform health endpoint check
  if curl -s -f "$RPC_HOST/ext/health" > /dev/null 2>&1; then
    # 2. EVM blockNumber check
    block_res=$(curl -s -X POST -H "Content-Type: application/json" \
      --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
      "$RPC_HOST/ext/bc/2368/rpc" 2>/dev/null || true)
    
    if [[ "$block_res" == *"result"* ]]; then
      echo "Node is healthy and serving RPC requests (Elapsed: ${elapsed}s)"
      exit 0
    fi
  fi

  sleep 2
done
