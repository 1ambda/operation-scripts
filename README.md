# Operation Scripts

## Recipe 1: check file was modified in last 1 minute and send slack message

```shell
$ CURRENT=/usr/bin/operation-scripts \     # where operation-scripts dir exists
  TARGET_FILE=/var/log/nginx/access.log \
  HISTORY_DIR=${PWD}/logs \
  PROGRAM_NAME=your_program \
  URL=https://slack.com/api/chat.postMessage \
  TOKEN=your-slack-token \
  CHANNEL=your-slack-channel &&
  ${CURRENT}/bin/stat.sh $TARGET_FILE ${CURRENT}/bin/slack.sh $HISTORY_DIR $PROGRAM_NAME $URL $TOKEN $CHANNEL > /dev/null 2>&1
```

Register this command to the crontab

## Recipe 2: tail + grep message and send it to slack

```shell
$ TARGET_FILE=/var/log/nginx/access.log \
  HISTORY_DIR=${PWD}/logs \
  PROGRAM_NAME=your_program \
  URL=https://slack.com/api/chat.postMessage \
  TOKEN=your-slack-token \
  CHANNEL=your-slack-channel &&
  nohup $PWD/bin/tail.sh $TARGET_FILE "grep POST | xargs -r $PWD/bin/slack.sh $HISTORY_DIR $PROGRAM_NAME $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > run.pid
```

- you can kill running tail script using `run.pid` (e.g `cat run.pid | xargs kill -15`) 
- if you do not want to grep, just starts with `xargs $PWD/bin/slack.sh ~`
- if you have to tail multiple log files, write script like

```shell
# tail-log.sh

HISTORY_DIR=${PWD}/operation-scripts/logs
BIN_DIR=$PWD/operation-scripts/bin
URL=https://slack.com/api/chat.postMessage
TOKEN=your-slack-token
CHANNEL=alert-kafka

nohup $BIN_DIR/tail.sh /data/kafka/logs/server.log "grep -E '(ERROR|WARN)' | xargs -r $BIN_DIR/slack.sh $HISTORY_DIR tail-server $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > tail-server.pid
nohup $BIN_DIR/tail.sh /data/kafka/logs/kafkaServer.out "grep -E '(ERROR|WARN)' | xargs -r $BIN_DIR/slack.sh $HISTORY_DIR tail-kafkaServerOut $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > tail-kafkaServerOut.pid
nohup $BIN_DIR/tail.sh /data/kafka/logs/state-change.log "grep -E '(ERROR|WARN)' | xargs -r $BIN_DIR/slack.sh $HISTORY_DIR tail-stateChange $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > tail-stateChange.pid
nohup $BIN_DIR/tail.sh /data/kafka/logs/controller.log "grep -E '(ERROR|WARN)' | xargs -r $BIN_DIR/slack.sh $HISTORY_DIR tail-controller $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > tail-controller.pid
nohup $BIN_DIR/tail.sh /data/kafka/logs/mirrorMaker.out "grep -E '(ERROR|WARN)' | xargs -r $BIN_DIR/slack.sh $HISTORY_DIR tail-mirrorMakerOut $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $! > tail-mirrorMakerOut.pid
```

- to kill all `tail.sh`, use `ps -ef | grep "$(cat *.pid)" | awk '{ print $2 }' | xargs kill -15`