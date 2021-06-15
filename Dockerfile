FROM ruby:3.0.0-slim

ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN apt-get update && apt-get install curl wget gnupg2 -y && \
    rm -rf /var/lib/apt/lists/*

# Add Pqsl
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install postgresql-client-12 build-essential \
    bc libcurl4-openssl-dev libpq-dev openssh-server git libsqlite3-dev -y && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN mkdir /game_on_auth
WORKDIR /game_on_auth

COPY Gemfile* ./
RUN bundle install
