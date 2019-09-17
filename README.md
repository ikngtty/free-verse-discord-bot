# 俳句じゃないやつ検出bot

A Discord bot to detect free verses. (WIP)

## Usage

### Detection

The bot joining to your server detects free verses and reports it
by a discord message automatically.

### Commands

Commands can be run by a mention to the bot.

Commands:

*   `@<bot> mecab <text>`
    *   Shows [MeCab][mecab] result about the specified text
        by a discord message.
*   `@<bot> info`
    *   **DEBUG MODE ONLY**
    *   Shows informations for debugging by discord messages.

## Development

### Requirements

When running or deploying this bot, set these environment variables.

*   `DISCORD_BOT_TOKEN`
    *   Required
*   `DEBUG_MODE`
    *   Not required
    *   To turn debug mode on, set `1` or `true`.

### Run

#### with Docker

Ruby's version is specified by `/.Dockerfile`.

```console
# prepare and run
./docker.sh
```

#### in Local

Ruby's version is specified by `/.ruby-version`.

It is required for running that MeCab, which programs are in
[redistribution](redistribution)
directory, is installed in your environment.

```console
# prepare
bundle install

# run
bundle exec ruby main.rb
```

### Deploy

```console
heroku create free-verse-discord-bot
heroku stack:set container
heroku config:set DISCORD_BOT_TOKEN=$DISCORD_BOT_TOKEN
heroku config:set DEBUG_MODE=$DEBUG_MODE
git push heroku master
heroku ps:scale bot=1
```

## License

### MeCab

This repository includes [MeCab][mecab] programs.

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

[mecab]:http://taku910.github.io/mecab/
