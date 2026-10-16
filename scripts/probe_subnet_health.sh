#!/usr/bin/env bash

# probe_subnet_health.sh
# Diagnostic probe for Kite Subnet-EVM RPC availability, sync status, and block production latency.

set -euo pipefail

RPC_URL="${1:-${SUBNET_RPC_URL:-http://127.0.0.1:9650/ext/bc/C/rpc}}"
TIMEOUT_SECONDS=5

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Kite Subnet-EVM Node Health Probe ===${NC}"
echo -e "Target RPC: ${RPC_URL}"
echo ""

rpc_call() {
    local method="$1"
    local params="${2:-[]}"
    curl -s --max-time "${TIMEOUT_SECONDS}" \
        -X POST \
        -H "Content-Type: application/json" \
        --data "{\"jsonrpc\":\"2.0\",\"method\":\"${method}\",\"params\":${params},\"id\":1}" \
        "${RPC_URL}"
}

# 1. Chain ID Probe
echo -n "1. Checking Chain ID... "
CHAIN_RES=$(rpc_call "eth_chainId")
if [[ -z "${CHAIN_RES}" ]]; then
    echo -e "${RED}FAILED (RPC unreachable)${NC}"
    exit 1
fi

CHAIN_HEX=$(echo "${CHAIN_RES}" | grep -o '"result":"[^"]*"' | cut -d'"' -f4 || true)
if [[ -n "${CHAIN_HEX}" ]]; then
    CHAIN_DEC=$(printf "%d" "${CHAIN_HEX}")
    echo -e "${GREEN}OK${NC} (Chain ID: ${CHAIN_DEC} / ${CHAIN_HEX})"
else
    echo -e "${RED}FAILED (Invalid response)${NC}"
    exit 1
fi

# 2. Block Height & Latency
echo -n "2. Querying latest block height... "
START_TS=$(date +%s%3N 2>/dev/null || python3 -c 'import time; print(int(time.time()*1000))')
BLOCK_RES=$(rpc_call "eth_blockNumber")
END_TS=$(date +%s%3N 2>/dev/null || python3 -c 'import time; print(int(time.time()*1000))')
LATENCY=$((END_TS - START_TS))

BLOCK_HEX=$(echo "${BLOCK_RES}" | grep -o '"result":"[^"]*"' | cut -d'"' -f4 || true)
if [[ -n "${BLOCK_HEX}" ]]; then
    BLOCK_DEC=$(printf "%d" "${BLOCK_HEX}")
    echo -e "${GREEN}OK${NC} (Block #${BLOCK_DEC}, RTT: ${LATENCY}ms)"
else
    echo -e "${RED}FAILED${NC}"
    exit 1
fi

# 3. Node Sync Status
echo -n "3. Verifying sync state... "
SYNC_RES=$(rpc_call "eth_syncing")
if echo "${SYNC_RES}" | grep -q '"result":false'; then
    echo -e "${GREEN}IN SYNC${NC} (Node is fully synchronized)"
else
    echo -e "${YELLOW}SYNCING${NC} (${SYNC_RES})"
fi

# 4. Peer Count
echo -n "4. Checking peer connections... "
PEER_RES=$(rpc_call "net_peerCount")
PEER_HEX=$(echo "${PEER_RES}" | grep -o '"result":"[^"]*"' | cut -d'"' -f4 || true)
if [[ -n "${PEER_HEX}" ]]; then
    PEER_DEC=$(printf "%d" "${PEER_HEX}")
    if [[ "${PEER_DEC}" -gt 0 ]]; then
        echo -e "${GREEN}OK${NC} (${PEER_DEC} active peers)"
    else
        echo -e "${YELLOW}WARNING${NC} (0 peers connected)"
    fi
else
    echo -e "${YELLOW}SKIPPED (net_peerCount not exposed)${NC}"
fi

echo ""
echo -e "${GREEN}✔ Node probe completed successfully.${NC}"
exit 0
