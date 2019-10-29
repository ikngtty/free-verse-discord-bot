# 俳句じゃないやつ検出bot

A Discord bot to detect free verses.

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

When running or deploying this bot, you need to create `.env` file in
the project directory by copying [`.env.template`](.env.template) file
or to set the environment variables.

*   in Local
    *   set the env vars -> they are used (`.env` file is ignored)
    *   prepare `.env` file -> they are loaded by `dotenv` gem
*   with Docker Compose
    *   set the env vars -> they are passed to the container by Docker Compose
        and are used there (`.env` file is ignored)
    *   prepare `.env` file -> they are loaded by Docker Compose and are used
        in the container
*   heroku
    *   set the env vars -> they are used

### Run

#### with Docker Compose

Ruby's version is specified by `/.Dockerfile`.

```console
# prepare and run
docker-compose up -d --build
```

#### in Local

Ruby's version is specified by `/.ruby-version`.

For running, these are required:

*   MeCab
    *   In [redistribution](redistribution) directory.
*   [mecab-ipadic-NEologd](https://github.com/neologd/mecab-ipadic-neologd)
*   Redis
    *   It should be running.
    *   The `REDIS_URL` environment variable should be set.

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
heroku addons:create heroku-redis:hobby-dev # *1
heroku ps:scale bot=1
```

\*1: This necessity is declared in `setup` steps in the `heroku.yml`
manifest file, but by
[this document](https://devcenter.heroku.com/articles/build-docker-images-heroku-yml#creating-your-app-from-setup),
automatic installations triggerd by it seem to be a beta function. So we should
install the add-on manually (or use the beta function by following the steps
in the document).

or use GitHub Integration.

### Test

#### with Docker

```console
docker run --name freeverse_test ikngtty/freeverse rspec
```

#### in Local

```console
bundle exec rspec
```

### Lint

#### in Local

```console
bundle exec rubocop
```

### Inspect

Enter this command in Local and we can get our bot's information through
Discord REST API.

```console
bundle exec ruby script/inspect.rb
```

## License

Files in this repository without [redistribution](redistribution) directory
are under the MIT license (the [LICENSE](LICENSE) file).

### MeCab

This repository includes [MeCab][mecab] programs.

Source of the main program is
[redistribution/mecab-0.996.tar.gz](redistribution/mecab-0.996.tar.gz)
, which is downloaded from
[here](https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE)
and is included under the BSD license, which copy is
[redistribution/mecab-0.996-license](redistribution/mecab-0.996-license)
.

[mecab]:http://taku910.github.io/mecab/
