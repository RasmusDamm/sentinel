#!/usr/bin/env bash

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1

root="$(cd "$script_path/.." && pwd)" || exit 1

source "$root/lib/lib_log.sh"

config_path="$root/config/sentinel.json"
log_path="$root/config/sentinel.json"

command -v jq >/dev/null 2>&1 || {
    printf 'Please install jq.\n' >&2
    exit 1
}

threshold="$(jq -er '.warningThreshold' "$config_path")" || exit 1

failed_count="$grep -c 'LOGIN_FAILED' "$log_path")" || exit 1

printf 'Failed logins: %s\n' "$failed_count"
prinf 'Warning threshold: %s\n' "$threshold"

if [[ "$failed_count" -ge "$threshold"]]; then
    log_warn "Advarsel: grænsen for fejlede login er nået."
fi

printf '%s\n' "$threshold"