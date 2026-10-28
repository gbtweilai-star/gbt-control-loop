#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_control_loop info
PYTHONPATH=src python -m gbt_control_loop check --payload '{}'
PYTHONPATH=src python -m gbt_control_loop run   --payload '{}'
