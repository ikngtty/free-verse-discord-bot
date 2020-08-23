FROM ikngtty/ruby-mecab

WORKDIR /usr/src/

# NOTE: Need not to install MeCab's IPA dictionary data, because
# mecab-ipadic-NEologd includes it. Instead, need to create the directory
# which mecab-ipadic should have created.
RUN cd /usr/src/mecab/mecab-0.996 \
  && mkdir -p $(mecab-config --dicdir)

# Install mecab-ipadic-NEologd
# NOTE: Instead of configuring that MeCab's `dicdir` is "mecab-ipadic-neologd",
# get "mecab-ipadic-neologd" to pretend to be "ipadic", default `dicdir`.
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
  && cd mecab-ipadic-neologd \
  && bin/install-mecab-ipadic-neologd -n -a -y -p /usr/local/lib/mecab/dic/ipadic

# About the application's body
WORKDIR /usr/src/app

## Download gem files
COPY Gemfile Gemfile.lock ./
RUN gem update && gem cleanup
# NOTE: throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 \
  && bundle config --global without dev \
  && bundle install

## Execute
COPY main.rb ./
COPY lib/ ./lib/
COPY spec/ ./spec/
CMD ["ruby", "main.rb"]
