FROM ruby:2.6

ENV LANG C.UTF-8

# Install MeCab
WORKDIR /usr/src/mecab
COPY redistribution/mecab-0.996.tar.gz ./
RUN tar zxf mecab-0.996.tar.gz \
  && rm mecab-0.996.tar.gz

WORKDIR /usr/src/mecab/mecab-0.996
RUN ./configure
RUN make
RUN make check
RUN make install
RUN ldconfig

# Install MeCab's IPA dictionary data
WORKDIR /usr/src/mecab
COPY redistribution/mecab-ipadic-2.7.0-20070801.tar.gz ./
RUN tar zxf mecab-ipadic-2.7.0-20070801.tar.gz \
  && rm mecab-ipadic-2.7.0-20070801.tar.gz

WORKDIR /usr/src/mecab/mecab-ipadic-2.7.0-20070801
RUN ./configure --with-charset=utf8
RUN make
RUN make install
RUN ldconfig

# About the application's body
WORKDIR /usr/src/app

## Download gem files
COPY Gemfile Gemfile.lock ./
RUN gem update && gem cleanup
# NOTE: throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 && bundle install

## Execute
COPY main.rb ./
COPY lib/ ./lib/
CMD ["ruby", "main.rb"]
