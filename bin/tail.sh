#!/usr/bin/env bash
# Usage: ./tail.sh <SCRIPT_LOG_DIR> <TARGET_LOG_FILE> <COMMAND>

function init_env()
{
    USAGE_TEXT="Usage: tail.sh <SCRIPT_LOG_DIR> <TARGET_LOG_FILE> <COMMAND>"
    FILE_MODIFICATION_INTERVAL=1 # minute
    LINE_NUMBER_TO_TAIL=1

    DATE_PROGRAM_NAME="date"
    STAT_PROGRAM_NAME="stat"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        DATE_PROGRAM_NAME="gdate"
        STAT_PROGRAM_NAME="gstat"
    fi

    DATE_PROGRAM=$(which $DATE_PROGRAM_NAME)
    STAT_PROGRAM=$(which $STAT_PROGRAM_NAME)

    GREP_PROGRAM=$(which grep)
    TAIL_PROGRAM=$(which tail)
    RM_PROGRAM=$(which rm)

    TIME_FORMAT=$($DATE_PROGRAM --date="$FILE_MODIFICATION_INTERVAL min ago" "+%Y/%m/%d %H:%M")
    NOW=$($DATE_PROGRAM --date="now" "+%Y-%m-%d %H:%M")
}

function parse_params()
{
    script_log_dir=$1
    if [[ $script_log_dir == "" ]]; then
        echo "No LOG_DIR specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    target_log_file=$1
    if [[ $target_log_file == "" ]]; then
        echo "No CHANNEL specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    command=$*
    if [[ $command == "" ]]; then
        echo "No TEXT specified, $USAGE_TEXT"
        exit 1
    fi
}

function is_file_modified()
{
    local file=$1
    local modification_time=$($STAT_PROGRAM -c %Y $file)
    local previous_check_time=$($DATE_PROGRAM --date="$FILE_MODIFICATION_INTERVAL min ago" +%s)

    filtered=""

    if [[ $modification_time -gt $previous_check_time ]]; then
        filtered=$($TAIL_PROGRAM -n$LINE_NUMBER_TO_TAIL $file)
        return 1
    else
        return 0
    fi
}

### start script ###

init_env
parse_params $@

is_file_modified $target_log_file

if [[ $? -eq 0 ]]; then
    exit 0
fi

$command $filtered
