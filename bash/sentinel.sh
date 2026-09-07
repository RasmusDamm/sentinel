#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname \
  "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/lib_log.sh"


require_command awk

collect_users() {
    log_info "Collecting users"
    log_section "Users"
    awk -F: '$3 >= 1000 && \
      $7 !~ /nologin|false/ {print $1}' \
      /etc/passwd
}

collect_services() {
    log_info "Collecting services"
    log_section "Services"
    systemctl list-units --type=service --state=running
}

collect_ports() {
    log_info "Collecting listening TCP ports"
    log_section "Listening TCP ports"
    ss -tlnp
}

collect_sudo_members() {
    log_info "Collecting sudo members"
    log_section "Sudo members"
    getent group sudo
}

main() {
    collect_users
    collect_services
    collect_ports
    collect_sudo_members
    log_info "Sentinel complete"
}

main "$@"

