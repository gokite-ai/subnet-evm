# Kite Subnet-EVM Observability Guide

This directory provides Prometheus scraping configurations and Grafana dashboards for monitoring Kite Subnet EVM nodes.

## Metrics Overview

Kite Subnet EVM exposes standard Prometheus telemetry endpoints on port `9650`:
- `/ext/metrics`: AvalancheGo base engine and platform metrics.
- `/ext/bc/<BlockchainID>/metrics`: Subnet EVM execution, mempool, and block production metrics.

### Key Metrics Monitored

| Metric Name | Type | Description |
|---|---|---|
| `subnet_evm_chain_head_block` | Gauge | Latest processed block height |
| `subnet_evm_chain_base_fee` | Gauge | Current block base fee (in wei) |
| `subnet_evm_chain_gas_used_total` | Counter | Total cumulative gas executed |
| `subnet_evm_tx_pool_pending` | Gauge | Pending transactions waiting in mempool |
| `subnet_evm_rpc_duration_seconds` | Histogram | JSON-RPC method execution latency |

## Quick Start

### 1. Prometheus Scrape Setup
Copy `metrics/prometheus.yml` into your Prometheus configuration directory or mount it via Docker:

```yaml
scrape_configs:
  - job_name: 'kite-subnet-evm'
    metrics_path: '/ext/metrics'
    static_configs:
      - targets: ['localhost:9650']
```

### 2. Import Grafana Dashboard
1. Open your Grafana instance (`http://localhost:3000`).
2. Navigate to **Dashboards** > **Import**.
3. Upload `dashboards/kite-subnet-overview.json` or paste its JSON content.
4. Select your Prometheus data source and click **Import**.
