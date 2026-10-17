#!/usr/bin/env bash
# Kite Subnet EVM Precompile Interface Audit Tool
set -euo pipefail

PRECOMPILE_DIR="${1:-./precompile/contracts}"

echo "============================================="
echo "Kite Subnet EVM Precompile Audit"
echo "Directory: $PRECOMPILE_DIR"
echo "============================================="

if [ ! -d "$PRECOMPILE_DIR" ]; then
  echo "Directory $PRECOMPILE_DIR not found. Exiting."
  exit 1
fi

echo "Scanning precompile contract packages..."
find "$PRECOMPILE_DIR" -maxdepth 2 -name "contract.go" | while read -r file; do
  pkg=$(basename "$(dirname "$file")")
  echo "Found precompile: $pkg -> $file"
done
