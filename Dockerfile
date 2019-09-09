FROM ruby:2.6
LABEL maintainer="kstarachowicz@gmail.com"
RUN apt-get update -yqq

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app

RUN bundle install
COPY . /usr/src/app

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
