#!/usr/bin/env bash
# Usage: ./tail-f.sh <TARGET_LOG_FILE> <COMMAND>

function init_env()
{
    USAGE_TEXT="Usage: tail-f.sh <TARGET_LOG_FILE> <COMMAND>"

    GREP_PROGRAM=$(which grep)
    TAIL_PROGRAM=$(which tail)
}

function parse_params()
{
    target_log_file=$1
    if [[ $target_log_file == "" ]]; then
        echo "No TARGET_LOG_FILE specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    command=$*
    if [[ $command == "" ]]; then
        echo "No TEXT specified, $USAGE_TEXT"
        exit 1
    fi
}

### start script ###

init_env
parse_params $@

tail -n0 -F $target_log_file | while read LINE; do
  $command $LINE
done
