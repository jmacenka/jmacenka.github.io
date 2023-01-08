#!/bin/sh
# Script to build the jekyll project static files with a docker-container

JEKYLL_ENV=production bundle exec jekyll b
#docker build -t jekyll .
#docker run --volume="$PWD:/srv/jekyll:Z" -t jekyll #TODO: Find a way to automate jekyll building