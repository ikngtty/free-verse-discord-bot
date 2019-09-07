FROM ruby:2.6

ENV LANG C.UTF-8

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN gem update && gem cleanup
# NOTE: throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 && bundle install

COPY . .
CMD ["ruby", "main.rb"]
