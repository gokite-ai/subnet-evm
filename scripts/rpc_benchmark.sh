#!/usr/bin/env bash
# Kite Subnet EVM RPC Benchmark Harness
set -euo pipefail

RPC_URL="${1:-http://127.0.0.1:9650/ext/bc/2368/rpc}"
ITERATIONS="${2:-20}"
CONCURRENCY="${3:-5}"

echo "============================================="
echo "Kite Subnet EVM RPC Benchmark & Load Tester"
echo "Target Endpoint: $RPC_URL"
echo "Total Iterations: $ITERATIONS"
echo "Concurrency: $CONCURRENCY"
echo "============================================="

measure_call() {
  local method="$1"
  local params="$2"
  curl -s -o /dev/null -w "%{time_total}\n" \
    -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"'"$method"'","params":'"$params"',"id":1}' \
    "$RPC_URL"
}

run_concurrent_test() {
  local method="$1"
  local params="$2"
  local count="$3"
  local pids=()
  local tmpfile
  tmpfile=$(mktemp)

  for i in $(seq 1 "$count"); do
    measure_call "$method" "$params" >> "$tmpfile" &
    pids+=($!)
    if (( i % CONCURRENCY == 0 )); then
      wait "${pids[@]}"
      pids=()
    fi
  done
  if [ ${#pids[@]} -gt 0 ]; then
    wait "${pids[@]}"
  fi
  cat "$tmpfile"
  rm -f "$tmpfile"
}
