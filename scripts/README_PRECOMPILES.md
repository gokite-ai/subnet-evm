# Precompile Audit & Verification Tool

The `scripts/precompile_audit.sh` tool performs automated static verification across custom and stateful Subnet-EVM precompiles.

## Capabilities
- Discovers all registered precompile modules under `precompile/contracts/`.
- Confirms the presence of generated Go contract bindings (`contract.go`).
- Inspects matching Solidity ABI specifications.
- Validates precompile 4-byte function selectors against registered dispatch tables.

## Usage

```bash
chmod +x scripts/precompile_audit.sh

# Run audit with default path
./scripts/precompile_audit.sh

# Run audit targeting specific precompile module
./scripts/precompile_audit.sh ./precompile/contracts
```
