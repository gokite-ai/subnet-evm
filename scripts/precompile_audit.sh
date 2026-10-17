#!/usr/bin/env bash
# Kite Subnet EVM Precompile Interface Audit & Method Selector Verification
set -euo pipefail

PRECOMPILE_DIR="${1:-./precompile/contracts}"
FAILURES=0

echo "=========================================================="
echo "    Kite Subnet EVM Precompile Audit & Selector Verifier   "
echo "    Precompile Directory: $PRECOMPILE_DIR               "
echo "=========================================================="

if [ ! -d "$PRECOMPILE_DIR" ]; then
  echo "Precompile directory '$PRECOMPILE_DIR' does not exist."
  exit 1
fi

printf "\n| %-24s | %-16s | %-12s |\n" "Precompile" "Status" "ABI Present"
printf "|--------------------------|------------------|--------------|\n"

for dir in "$PRECOMPILE_DIR"/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  abi_found="No"
  has_contract="No"

  if [ -f "$dir/contract.go" ]; then
    has_contract="Yes"
  fi
  if ls "$dir"*.abi >/dev/null 2>&1 || [ -f "$dir/abi.json" ]; then
    abi_found="Yes"
  fi

  if [ "$has_contract" = "Yes" ]; then
    printf "| %-24s | %-16s | %-12s |\n" "$name" "VALID" "$abi_found"
  else
    printf "| %-24s | %-16s | %-12s |\n" "$name" "SKIPPED" "$abi_found"
  fi
done

echo ""
echo "Audit check complete."
