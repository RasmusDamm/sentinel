#!/bin/bash

set -euo pipefail

count_failed() {
  local file="$1" 

  awk '$2 == "LOGIN_FAILED" { n++ }
  END { print n + 0 }' "$file"
}

count_total() {
  local file="$1"
  wc -l < "$file"
}

total="$(count_total "$1")"
failed="$(count_failed "$1")"

# Her bygges en JSON-fil fra bunden af, og her oprettes jq-variablerne $total og $failed
# ud fra Bash-variablerne $total og $failed. Dernæst bliver JSON-objektet bygget og afslutningsvist
# sendt til rapport.json, som så opretter en ny JSON-fil, og hvis den allerede eksisterer, så
# bliver den overskrevet.
jq -n --argjson total "$total" --argjson failed "$failed" \
'{total_lines:$total, failed_logins:$failed}' > rapport.json