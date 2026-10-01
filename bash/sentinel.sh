#!/usr/bin/env bash

set -euo pipefail

script_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" || exit 1

root="$(cd "$script_path/.." && pwd)" || exit 1

source "$root/lib/lib_log.sh"

config_path="$root/config/sentinel.json"

log_path="$root/auth-demo.log"

read_config() {
    if ! threshold="$(jq -er '.warningThreshold' "$config_path")"; then
        log_error "Invalid JSON data in sentinel.json"
        exit 1
    fi

    printf '%s\n' "$threshold"
}

get_failed_count() {
  local file="$1"

  failed_count=$(awk '$2 == "LOGIN_FAILED" { n++ }
       END { print n + 0 }' "$file")
}

check_threshold() {
    log_section "Threshold check"

    threshold="$(read_config)"

    if [[ "$failed_count" -ge "$threshold" ]]; then
      log_warn "Warning: The threshold for failed logins has been reached."
    else 
      log_info "Passed: Threshold check for failed logins."
    fi
}

create_report() {

  log_section "Create Report"

  log_info "Creating report"

  local file="$1"

  total_count=$(wc -l < "$file")

  jq -n --argjson total "$total_count" --argjson failed "$failed_count" \
  '{
    total_lines:$total,
    failed_logins:$failed
  }' > rapport.json

  log_info "Report created"
}

collect_users() {
  log_section "Users"
  log_info "Collecting interactive users"

  awk -F: '
    $3 >= 1000 && $7 !~ /nologin|false/ {
      print $1
    }
  ' /etc/passwd
}

collect_sudo_members() {
  log_section "Sudo members"

  local line

  line="$(getent group sudo)" || {
    log_warn "no sudo group on this host"
    return 0
  }

  printf '%s\n' "${line##*:}" | tr ',' '\n'
}

collect_services() {
  log_section "Services"

  require_command systemctl || return 0

  systemctl list-units \
    --type=service \
    --state=running \
    --no-legend \
    --no-pager |
    awk '{print $1}'
}

collect_ports() {
  log_section "Listening ports"

  require_command ss || return 0

  ss -tlnp |
    tail -n +2 |
    awk '{print $4, $6}'
}

main() {
  collect_users
  collect_services
  collect_ports
  collect_sudo_members
  
  get_failed_count "$log_path"
  check_threshold
  create_report "$log_path"

  log_info "Sentinel complete"
}

main "$@"