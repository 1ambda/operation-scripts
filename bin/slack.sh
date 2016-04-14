#!/usr/bin/env bash
# Usage: ./slack.sh <LOG_DIR> <PROGRAM> <WEBHOOK_URL> <TOKEN> <CHANNEL> <TEXT>

function init_env()
{
    MAX_RETRY_COUNT=5
    USAGE_TEXT="Usage: slack.sh <LOG_DIR> <PROGRAM> <WEBHOOK_URL> <TOKEN> <CHANNEL> <TEXT>"
    CURL_PROGRAM=$(which curl)
    DATE_PROGRAM=$(which date)
    CURRENT_DATE=$($DATE_PROGRAM +\%Y\%m\%d)
}

function parse_parmas()
{
    log_dir=$1
    if [[ $log_dir == "" ]]; then
        echo "No LOG_DIR specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    program=$1
    if [[ $program == "" ]]; then
        echo "No PROGRAM specified, $USAGE_TEXT"
        exit 1
    fi

    LOG_FILE="$log_dir/$program-$CURRENT_DATE.log"

    shift
    webhook_url=$1
    if [[ $webhook_url == "" ]]; then
        echo "No WEBHOOK_URL specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    token=$1
    if [[ $token == "" ]]; then
        echo "No TOKEN specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    channel=$1
    if [[ $channel == "" ]]; then
        echo "No CHANNEL specified, $USAGE_TEXT"
        exit 1
    fi

    shift
    text=$*
    if [[ $text == "" ]]; then
        echo "No TEXT specified, $USAGE_TEXT"
        exit 1
    fi

    escapedText=$(echo $text | sed 's/"//g' | sed "s/'//g")
}

### start script ###

init_env
parse_parmas $@

result=""
current_retry_count=0

while [[ "$result" != *$HOSTNAME* ]]; do
    if [[ $current_retry_count -eq $MAX_RETRY_COUNT ]]; then
        break # stop
    fi

    result=`$CURL_PROGRAM -X POST -F token=$token -F channel=$channel -F text="$escapedText" -F icon_emoji=:x: -F username=$HOSTNAME:$program $webhook_url`
    current_retry_count=$(($current_retry_count + 1))
done

if [[ $current_retry_count -eq $MAX_RETRY_COUNT ]]; then
    # retried, but failed to send SLACK message
    current_time=$(/bin/date +"%Y-%m-%d %H:%M:%S")
    failed_log="$current_time PROGRAM=$program WEBHOOK_URL=$webhook_url TOKEN=$token MESSAGE=$escapedText"
    echo $failed_log >> $LOG_FILE
fi

