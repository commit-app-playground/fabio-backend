#!/bin/bash
# If ruby/yarn dependencies are declared in the Dockerfile
# The image requires new build every time a dependency is added
echo "Installing missing gems"
bundle install

echo "Installing yarn packages"
yarn install

echo "Sync the database migrations"
bundle exec rails db:create db:migrate

# https://www.maketecheasier.com/run-bash-commands-background-linux/
echo "Watch sass files for compilation in background"
yarn build:css --watch &>/dev/null &

echo "Removing potential pre-existing server.pid for Rails."
rm -f tmp/pids/server.pid

echo 'Starting Rails Server in development mode'
bundle exec rails s -p 3000 -b 0.0.0.0
