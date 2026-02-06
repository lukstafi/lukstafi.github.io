#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Building notes ==="
"$root_dir/scripts/build_notes_html.sh"

echo "=== Building JCA paper ==="
"$root_dir/scripts/build_jca_html.sh"

echo "=== Building agent-collab papers ==="
"$root_dir/scripts/build_agent_collab_html.sh"

echo "=== All builds complete ==="
