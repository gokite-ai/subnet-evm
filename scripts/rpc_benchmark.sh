#!/usr/bin/env bash
# Kite Subnet EVM RPC Benchmark & Throughput Tester
set -euo pipefail

RPC_URL="${1:-http://127.0.0.1:9650/ext/bc/2368/rpc}"
ITERATIONS="${2:-30}"
CONCURRENCY="${3:-5}"

echo "============================================="
echo "  Kite Subnet EVM RPC Benchmark Suite"
echo "  Target Endpoint : $RPC_URL"
echo "  Iterations      : $ITERATIONS"
echo "  Concurrency     : $CONCURRENCY"
echo "============================================="

measure_call() {
  local method="$1"
  local params="$2"
  curl -s -o /dev/null -w "%{time_total}\n" \
    -X POST -H "Content-Type: application/json" \
    --data '{"jsonrpc":"2.0","method":"'"$method"'","params":'"$params"',"id":1}' \
    "$RPC_URL"
}

bench_method() {
  local name="$1"
  local method="$2"
  local params="$3"
  local tmpfile
  tmpfile=$(mktemp)

  for _ in $(seq 1 "$ITERATIONS"); do
    measure_call "$method" "$params" >> "$tmpfile" &
  done
  wait

  # Compute stats using awk
  awk '
    BEGIN { min=999999; max=0; sum=0; count=0 }
    {
      val = $1 * 1000
      sum += val
      count++
      if (val < min) min = val
      if (val > max) max = val
      vals[count] = val
    }
    END {
      avg = sum / count
      asort(vals)
      p95_idx = int(count * 0.95)
      if (p95_idx < 1) p95_idx = 1
      p95 = vals[p95_idx]
      printf "| %-22s | %8.2f ms | %8.2f ms | %8.2f ms | %8.2f ms |\n", "'"$name"'", min, avg, max, p95
    }
  ' "$tmpfile"
  rm -f "$tmpfile"
}

printf "\n| %-22s | %11s | %11s | %11s | %11s |\n" "Method" "Min" "Avg" "Max" "p95"
printf "|------------------------|-------------|-------------|-------------|-------------|\n"

bench_method "eth_blockNumber" "eth_blockNumber" "[]"
bench_method "eth_chainId" "eth_chainId" "[]"
bench_method "eth_gasPrice" "eth_gasPrice" "[]"
bench_method "eth_getBlockLatest" "eth_getBlockByNumber" '["latest", false]'

echo "\nBenchmark completed successfully."
