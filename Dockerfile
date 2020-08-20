FROM ruby:2.6

ENV LANG C.UTF-8

# Install MeCab
WORKDIR /usr/src/mecab
COPY redistribution/mecab-0.996.tar.gz ./
RUN tar zxf mecab-0.996.tar.gz \
  && rm mecab-0.996.tar.gz

WORKDIR /usr/src/mecab/mecab-0.996
RUN ./configure \
  && make \
  && make check \
  && make install \
  && ldconfig

# NOTE: Need not to install MeCab's IPA dictionary data, because
# mecab-ipadic-NEologd includes it. Instead, need to create the directory
# which mecab-ipadic should have created.
RUN mkdir -p $(mecab-config --dicdir)

# Install mecab-ipadic-NEologd
WORKDIR /usr/src/
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
# NOTE: Instead of configuring that MeCab's `dicdir` is "mecab-ipadic-neologd",
# get "mecab-ipadic-neologd" to pretend to be "ipadic", default `dicdir`.
RUN mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -a -y\
      -p /usr/local/lib/mecab/dic/ipadic

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
