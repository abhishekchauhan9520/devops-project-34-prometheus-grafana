# Project 34 — Prometheus + Grafana Infrastructure Monitoring

Production-style infrastructure monitoring lab built around Prometheus, Grafana, Alertmanager, node_exporter, and blackbox_exporter.

## Architecture

```text
node_exporter ─────┐
blackbox_exporter ─┼──> Prometheus ──> Alertmanager
                   │        │
                   │        └────> Grafana
                   │
                   └── host / endpoint metrics
```

## Stack

- Prometheus 3.13.2 (LTS)
- Grafana OSS 13.1.3
- Alertmanager 0.34.0
- node_exporter 1.12.1
- blackbox_exporter 0.28.0

## What this demonstrates

- Metrics collection and scrape configuration
- Recording rules for reusable infrastructure signals
- Alerting rules for availability and resource pressure
- Alertmanager grouping/routing/inhibition
- Grafana dashboards provisioned from Git
- Blackbox HTTP probing
- Persistent Prometheus and Grafana storage
- Docker Compose orchestration
- Monitoring configuration as code

## Run locally

```bash
docker compose up -d
```

Open:

- Prometheus: http://localhost:9090
- Alertmanager: http://localhost:9093
- Grafana: http://localhost:3000

Grafana credentials default to `admin` / `admin` for this lab only. Override them with environment variables before any shared deployment.

## Validation

```bash
bash scripts/test-config.sh
```

GitHub Actions runs Prometheus `promtool` checks and validates the Compose file using Docker Compose.

## Production notes

- Do not expose Prometheus or Alertmanager directly to the public Internet.
- Replace default Grafana credentials immediately.
- Put Grafana behind SSO/RBAC and TLS.
- Use durable storage and backups for Prometheus/Grafana.
- Add remote_write/long-term storage for larger environments.
- Add high-availability Prometheus/Alertmanager for critical production use.

## License

MIT
