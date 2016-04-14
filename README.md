# Operation Scripts

## Recipe 1: Tail error log and send it to slack

```
$ ./bin/tail.sh ./log /var/log/nginx/access.log ./bin/slack.sh $PWD/log PROGRAM_NAME https://slack.com/api/chat.postMessage SLACK_TOKEN SLACK_CHANNEL
```

You run this command every minute by registering it to the crontab
 
 