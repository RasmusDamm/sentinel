#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "brug: $0 FIL" >&2
    exit 1
fi

file="$1"

if [[ -f "$file" ]]; then
    lines=$(wc -l < "$file")
    echo "$file har $lines linjer"
    exit 0
else
    echo "findes ikke: $file" >&2
    exit 1
fi