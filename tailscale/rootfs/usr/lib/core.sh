#!/usr/bin/env bash
# shellcheck shell=bash

function log.error_or_warning() {
    local warning_only="$1"; shift
    if ! bashio::var.has_value "${warning_only}"; then
        bashio::log.error "$@"
    else
        bashio::log.warning "$@"
    fi
}

# ------------------------------------------------------------------------------
# Makes a call to the Home Assistant REST API.
#
# Arguments:
#   $1 HTTP Method (GET/POST)
#   $2 API Resource requested
#   $3 In case of a POST method, this parameter is the JSON to POST (optional)
#   $4 jq filter command (optional)
#
# Options (after arguments):
#   -s "Silent" Supress error message in case of a 404 Not found HTTP status code
#   -w "Warning only" Log only warnings instead of errors
# ------------------------------------------------------------------------------
function core.api() {
    local method="${1}"; shift
    local resource="/core/api/${1}"; shift
    local data='{}'
    if [[ "${method}" = "POST" ]]; then
        data="${1}"; shift
    fi
    local filter=
    if [[ -n "${1:-}" && "${1::1}" != "-" ]]; then
        filter="${1}"; shift
    fi

    local o
    local silent=
    local warning_only=
    while getopts "sw" o; do
        case "${o}" in
            s)
                silent=1
                ;;
            w)
                warning_only=1
                ;;
            *)
                ;;
        esac
    done

    local auth_header='Authorization: Bearer'
    local response
    local status

    bashio::log.trace "${FUNCNAME[0]}" "$@"

    if [[ -n "${__BASHIO_SUPERVISOR_TOKEN:-}" ]]; then
        auth_header="Authorization: Bearer ${__BASHIO_SUPERVISOR_TOKEN}"
    fi

    if ! response=$(curl --silent --show-error \
        --write-out '\n%{http_code}' --request "${method}" \
        -H "${auth_header}" \
        -H "Content-Type: application/json" \
        -d "${data}" \
        "${__BASHIO_SUPERVISOR_API}${resource}"
    ); then
        bashio::log.debug "${response}"
        log.error_or_warning "${warning_only}" "Something went wrong contacting the API"
        return "${__BASHIO_EXIT_NOK}"
    fi

    status=${response##*$'\n'}
    response=${response%"$status"}

    bashio::log.debug "Requested API resource: ${__BASHIO_SUPERVISOR_API}${resource}"
    bashio::log.debug "Request method: ${method}"
    bashio::log.debug "Request data: ${data}"
    bashio::log.debug "API HTTP Response code: ${status}"
    bashio::log.debug "API Response: ${response}"

    if [[ "${status}" -eq 400 ]]; then
        log.error_or_warning "${warning_only}" "Requested resource ${resource} was called with a bad request"
        return "${__BASHIO_EXIT_NOK}"
    fi

    if [[ "${status}" -eq 401 ]]; then
        log.error_or_warning "${warning_only}" "Unable to authenticate with the API, permission denied"
        return "${__BASHIO_EXIT_NOK}"
    fi

    if [[ "${status}" -eq 403 ]]; then
        log.error_or_warning "${warning_only}" "Unable to access the API, forbidden"
        return "${__BASHIO_EXIT_NOK}"
    fi

    if [[ "${status}" -eq 404 ]]; then
        if ! bashio::var.has_value "${silent}"; then
            log.error_or_warning "${warning_only}" "Requested resource ${resource} was not found"
        fi
        return "${__BASHIO_EXIT_NOK}"
    fi

    if [[ "${status}" -eq 405 ]]; then
        log.error_or_warning "${warning_only}" "Requested resource ${resource} was called using an unallowed method"
        return "${__BASHIO_EXIT_NOK}"
    fi

    if [[ "${status}" -ne 200 && "${status}" -ne 201 ]]; then
        log.error_or_warning "${warning_only}" "Unknown HTTP error ${status} occurred"
        return "${__BASHIO_EXIT_NOK}"
    fi

    if bashio::var.has_value "${filter}"; then
        bashio::log.debug "Filtering response using: ${filter}"
        response=$(bashio::jq "${response}" "${filter}")
    fi

    echo "${response}"
    return "${__BASHIO_EXIT_OK}"
}
