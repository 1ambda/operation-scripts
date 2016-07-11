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
  ${CURRENT}/bin/tail.sh $TARGET_FILE "${PWD}/bin/slack.sh $HISTORY_DIR $PROGRAM_NAME $URL $TOKEN $CHANNEL" > /dev/null 2>&1
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
  nohup $PWD/bin/tail.sh $TARGET_FILE "$(which grep) POST | $(which xargs) $PWD/bin/slack.sh $HISTORY_DIR $PROGRAM_NAME $URL $TOKEN $CHANNEL" > /dev/null 2>&1 & echo $1 > run.pid
```

You can kill running tail script using `run.pid` (e.g `cat run.pid | xargs kill -15`) 
