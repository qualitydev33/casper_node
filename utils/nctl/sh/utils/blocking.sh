#!/usr/bin/env bash

#######################################
# Awaits for the chain to proceed N eras.
# Arguments:
#   Network ordinal identifier.
#   Node ordinal identifier.
#   Future era offset to apply.
#######################################
function await_n_eras()
{
    local OFFSET=${1}
    local EMIT_LOG=${2:-false}
    local SLEEP_INTERVAL=${3:-'20.0'}
    local NODE_ID=${4:-''}
    local CURRENT
    local FUTURE

    CURRENT=$(get_chain_era "$NODE_ID")
    FUTURE=$((CURRENT + OFFSET))

    while [ "$CURRENT" -lt "$FUTURE" ];
    do
        if [ "$EMIT_LOG" = true ]; then
            log "current era = $CURRENT :: future era = $FUTURE ... sleeping $SLEEP_INTERVAL seconds"
        fi
        sleep "$SLEEP_INTERVAL"
        CURRENT=$(get_chain_era "$NODE_ID")
    done

    if [ "$EMIT_LOG" = true ]; then
        log "current era = $CURRENT"
    fi
}

#######################################
# Awaits for the chain to proceed N blocks.
# Arguments:
#   Network ordinal identifier.
#   Node ordinal identifier.
#   Future block height offset to apply.
#######################################
function await_n_blocks()
{
    local OFFSET=${1}
    local EMIT_LOG=${2:-false}
    local NODE_ID=${3:-''}

    local CURRENT
    local FUTURE

    CURRENT=$(get_chain_height "$NODE_ID")
    FUTURE=$((CURRENT + OFFSET))

    while [ "$CURRENT" -lt "$FUTURE" ];
    do
        if [ "$EMIT_LOG" = true ]; then
            log "current block height = $CURRENT :: future height = $FUTURE ... sleeping 2 seconds"
        fi
        sleep 2.0
        CURRENT=$(get_chain_height "$NODE_ID")
    done

    if [ "$EMIT_LOG" = true ]; then
        log "current block height = $CURRENT"
    fi
}

#######################################
# Awaits for the chain to proceed N eras.
# Arguments:
#   Network ordinal identifier.
#   Node ordinal identifier.
#   Future era offset to apply.
#######################################
function await_until_era_n()
{
    local ERA=${1}
    local EMIT_LOG=${2:-false}

    while [ "$(get_chain_era)" -lt "$ERA" ];
    do
        if [ "$EMIT_LOG" = true ]; then
            log "waiting for future era = $ERA ... sleeping 2 seconds"
        fi
        sleep 2.0
    done
}

#######################################
# Awaits for the chain to proceed N blocks.
# Arguments:
#   Network ordinal identifier.
#   Node ordinal identifier.
#   Future block offset to apply.
#######################################
function await_until_block_n()
{
    local HEIGHT=${1}

    while [ "$HEIGHT" -lt "$(get_chain_height)" ];
    do
        sleep 10.0
    done
}
