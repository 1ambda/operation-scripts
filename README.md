# Operation Scripts

## Recipe 1: check error was occurred in last 1 minute and send it to slack 

```shell
$ ./bin/stat.sh /var/log/nginx/access.log ./bin/slack.sh $PWD/logs PROGRAM_NAME https://slack.com/api/chat.postMessage SLACK_TOKEN SLACK_CHANNEL
```

Register this command to the crontab

## Recipe 2: tail error and send it to slack

```shell
nohup ./bin/tail.sh /var/log/nginx/access.log ./bin/slack.sh $PWD/logs PROGRAM_NAME https://slack.com/api/chat.postMessage SLACK_TOKEN SLACK_CHANNEL > /dev/null 2>&1&
```
