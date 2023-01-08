#!/bin/sh
# Script to initially install basic dependencies, neede to run the project

echo "NOW: Install basic dependencies..."
sudo apt update
sudo apt install clang make ruby-dev libffi-dev ruby-full build-essential zlib1g-dev git docker docker-compose

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gem install jekyll bundler
bundle install

echo "DONE: Basic Dependencies installed..."
