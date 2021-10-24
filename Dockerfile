# https://docs.docker.com/samples/rails/#define-the-project
# docker scan (Snyk) recommendation
FROM ruby:slim

RUN apt update -qq && apt upgrade -y

RUN apt install -y    \
  # https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
  autoconf            \
  bison               \
  build-essential     \
  libssl-dev          \
  libyaml-dev         \
  libreadline6-dev    \
  zlib1g-dev          \
  libncurses5-dev     \
  libffi-dev          \
  libgdbm6            \
  libgdbm-dev         \
  libdb-dev           \
  # Postgres lib to build pg gem
  postgresql-contrib  \
  libpq-dev           \
  # https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable
  npm

RUN npm install --global yarn

# https://hub.docker.com/_/ruby#:~:text=a%20Dockerfile%20in-,your,-Ruby%20app%20project
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /src
COPY . .
RUN chmod +x bin/docker-entrypoint.sh
EXPOSE 3000
