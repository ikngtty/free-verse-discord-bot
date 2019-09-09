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

It is required for running that Mecab, which programs are in
[redistribution](redistribution)
directory, is installed in your environment.

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

## License

### Mecab

This repository includes
[Mecab](http://taku910.github.io/mecab/)
programs.

Source of the main program is
[redistribution/mecab-0.996.tar.gz](redistribution/mecab-0.996.tar.gz)
, which is downloaded from
[here](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE)
and is included under the BSD license, which copy is
[redistribution/mecab-0.996-license](redistribution/mecab-0.996-license)
.

IPA dictionary data is
[redistribution/mecab-ipadic-2.7.0-20070801.tar.gz](redistribution/mecab-ipadic-2.7.0-20070801.tar.gz)
, which is downloaded from
[here](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM)
and is included under the license which copy is
[redistribution/mecab-ipadic-2.7.0-20070801-license](redistribution/mecab-ipadic-2.7.0-20070801-license)
.
