#!/usr/bin/env bash

if [ ! -z $1 ]; then
    eval $(awsu -p $1) && jq -n --arg AWS_SESSION_TOKEN "$AWS_SESSION_TOKEN" --arg AWSU_EXPIRES "$AWSU_EXPIRES" --arg AWS_ACCESS_KEY_ID "$AWS_ACCESS_KEY_ID" --arg AWS_SECRET_ACCESS_KEY "$AWS_SECRET_ACCESS_KEY" '{ "Version": 1, "AccessKeyId": $AWS_ACCESS_KEY_ID, "SecretAccessKey": $AWS_SECRET_ACCESS_KEY, "SessionToken":  $AWS_SESSION_TOKEN, "Expiration":  $AWSU_EXPIRES}'
fi
