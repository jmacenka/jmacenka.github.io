#!/bin/sh
# Scripct to be run as sync-job to pull and build the Repo which will be served by a local Web-Server
# Created by Jan Macenka @ 07 Jan 2023

timestamp_start=$(date +%s)

cd /root/jmacenka.github.io
git -C /root/jmacenka.github.io pull
#docker build -t jekyll .
#docker run -rm --volume="/root/jmacenka.github.io:/srv/jekyll:Z" -t jekyll #TODO: Find a way to automate jekyll building
JEKYLL_ENV=production bundle exec jekyll b

timestamp_stop=$(date +%s)

echo "Start: $timestamp_start, Stop: $timestamp_stop" >> /var/log/gh-pages-syncjob.log