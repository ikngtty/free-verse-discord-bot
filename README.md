# 俳句じゃないやつ検出bot

A Discord bot to detect free verses. (WIP)

## Requirements

When running or deploying this bot, set these environment variables.

*   DISCORD_BOT_TOKEN

## Run

### with Docker

Ruby's version is specified by `/.Dockerfile`.

```console
# prepare and run
./docker.sh
```

### in Local

Ruby's version is specified by `/.ruby-version`.

```console
# prepare
bundle install

# run
bundle exec ruby main.rb
```

## Deploy

```console
heroku create free-verse-discord-bot
heroku stack:set container
heroku config:set DISCORD_BOT_TOKEN=$DISCORD_BOT_TOKEN
git push heroku master
heroku ps:scale bot=1
```
