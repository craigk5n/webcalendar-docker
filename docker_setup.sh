#!/bin/bash
#
# Create a container with nginx and PHP 7.1 to use with WebCalendar.
# This script only needs to be run once to setup the container.
# This script will also startup the container.  Note that it can take 5
# or so minutes for all the services of the container to be configured
# on the initial startup.
#
# The WebCalendar files and the SQLite database are shared from your
# local filesystem to the container.  So you can safely destroy the
# container at any time without losing data.  If you're a developer,
# you can just edit the files locally.
#
# To start/stop up this container in the future, you can just use the
# follwing docker commands:
#
#	docker start webcalendar-php7
#	docker stop webcalendar-php7
#
# To get shell access to your container:
#
#	docker exec -ti webcalendar-php7 /bin/sh

# Grab the latest webcalendar from github if we don't already have it.
if [ -d webcalendar ]; then
  echo "WebCalendar already downloaded."
else
  echo "Downloading latest WebCalendar from github"
  curl -o webcalendar-master.zip https://codeload.github.com/craigk5n/webcalendar/zip/master
  unzip webcalendar-master.zip
  mv webcalendar-master webcalendar
fi

if [ -f "webcalendar/includes/settings.php" ]; then
  # already installed settings.php
  echo "Previously copied settings.php."
else
  # Copy over settings.php file so user does not need to
  # go through the WebCalendar install pages to setup
  # the db.
  cp settings.php-docker webcalendar/includes/settings.php
fi

if [ ! -d data ]; then
  mkdir data
fi

# Copy the sqlite file it not already there
if [ -f data/webcalendar.sqlite ]; then
  echo "WebCalendar SQLite file previously copied."
else
  echo "Copying WebCalendar SQLite file."
  cp webcalendar.sqlite-docker data/webcalendar.sqlite
fi

# Load base image for nginx and php 7.1
docker pull skiychan/nginx-php7:latest

# Now run the command to configure the container
docker run --name webcalendar-php7 -p 8080:80 -v `pwd`/webcalendar:/data/www/webcalendar -v `pwd`/data:/web/data -d skiychan/nginx-php7

echo "Container created and started."
echo "Wait 5 or so minutes for all the services to be configured."
echo "WebCalendar can be accessed at:"
echo "  http://localhost:8080/webcalendar"
echo ""
echo "To get shell access on the container:"
echo "  docker exec -ti webcalendar-php7 /bin/sh"
echo ""

exit 0

