# Local Kite Subnet-EVM Multi-Node Cluster

This directory provides Docker Compose orchestration files for spinning up a local two-validator cluster with automated health checks.

## Architecture

- **`kite-validator-1`**: Primary bootstrap validator listening on RPC `9650` and Staking `9651`.
- **`kite-validator-2`**: Secondary validator peering with validator-1 on Staking `9653`.
- **`node-health-probe.sh`**: Automated readiness script for CI testing.

## Quick Start

```bash
# 1. Start cluster in background
docker compose -f docker/docker-compose-cluster.yml up -d

# 2. Probe node health and block production
chmod +x docker/node-health-probe.sh
./docker/node-health-probe.sh http://localhost:9650 45

# 3. Stop and clean up
docker compose -f docker/docker-compose-cluster.yml down -v
```
