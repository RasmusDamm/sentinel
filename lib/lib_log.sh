_log()
{
    local level="$1"
    shift

    local msg="$*"

    printf '[%s] [%s] %s\n' \
        "$(date -Iseconds)" "$level" "$msg" >&2

}

log_info()
{
    _log "INFO" "$@"
}

log_warn()
{
    _log "WARN" "$@"
}

log_error()
{
    _log "ERROR" "$@"
}

log_section()
{
    local title="$*"

    printf '\n=== %s ===\n' "$title" >&2
}

require_command()
{
    local command="$1"

    if ! command -v "$command" >/dev/null 2>&1; then
        log_error "Missing command: $command"
        return 1
    fi
}








