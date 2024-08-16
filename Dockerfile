FROM ruby:3.1

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem update --system 3.3.20 && \
    bundle install
RUN apt-get update && apt-get install -y graphviz


COPY . /app