FROM ruby:2.6

ENV LANG C.UTF-8

RUN gem update && gem cleanup

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
CMD ["ruby", "main.rb"]
