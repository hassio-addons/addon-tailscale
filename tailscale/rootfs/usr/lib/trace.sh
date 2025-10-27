#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Checks if we are currently running in trace mode, based on the bashio log module.
# ------------------------------------------------------------------------------
function is_bashio_log_level_trace() {
    if [[ "${__BASHIO_LOG_LEVEL}" -lt "${__BASHIO_LOG_LEVEL_TRACE}" ]]; then
        return "${__BASHIO_EXIT_NOK}"
    fi

    return "${__BASHIO_EXIT_OK}"
}
