_log() {
  local level="$1"
  shift

  printf '[%s] [%s] %s\n' \
    "$(date '+%F %T')" "$level" "$*" >&2
}

log_info()  { _log INFO  "$@"; }
log_warn()  { _log WARN  "$@"; }
log_error() { _log ERROR "$@"; }

log_section() {
  printf '\n=== %s ===\n' "$1" >&2
}

require_command() {
  local cmd="$1"

  command -v "$cmd" >/dev/null 2>&1 || {
    log_error "missing command: $cmd"
    return 1
  }
}