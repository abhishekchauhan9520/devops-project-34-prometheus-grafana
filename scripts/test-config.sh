#!/usr/bin/env bash
set -euo pipefail

fail() { echo "FAIL: $1" >&2; exit 1; }

for f in \
  docker-compose.yml \
  prometheus/prometheus.yml \
  prometheus/rules/recording.yml \
  prometheus/rules/alerts.yml \
  alertmanager/alertmanager.yml \
  blackbox/config.yml \
  grafana/provisioning/datasources/prometheus.yml \
  grafana/provisioning/dashboards/default.yml \
  grafana/dashboards/infrastructure.json; do
  [[ -f "$f" ]] || fail "missing $f"
done

command -v python3 >/dev/null || fail "python3 is required"
python3 - <<'PY'
import json
from pathlib import Path
json.loads(Path('grafana/dashboards/infrastructure.json').read_text())
print('dashboard JSON: PASS')
PY

grep -q 'image: prom/prometheus:v3.13.2' docker-compose.yml || fail 'Prometheus image not pinned'
grep -q 'image: grafana/grafana:13.1.3' docker-compose.yml || fail 'Grafana image not pinned'
grep -q 'image: prom/alertmanager:v0.34.0' docker-compose.yml || fail 'Alertmanager image not pinned'
grep -q 'image: prom/node-exporter:v1.12.1' docker-compose.yml || fail 'node_exporter image not pinned'
grep -q 'image: prom/blackbox-exporter:v0.28.0' docker-compose.yml || fail 'blackbox exporter image not pinned'
grep -q 'alertmanagers:' prometheus/prometheus.yml || fail 'Prometheus Alertmanager integration missing'
grep -q 'probe_success' prometheus/rules/alerts.yml || fail 'blackbox alert missing'
grep -q 'inhibit_rules:' alertmanager/alertmanager.yml || fail 'Alertmanager inhibition missing'
grep -q 'editable: false' grafana/provisioning/datasources/prometheus.yml || fail 'datasource should be immutable'

echo 'Project 34 configuration assertions passed.'
