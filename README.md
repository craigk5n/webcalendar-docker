# WebCalendar Docker Setup

The files here will be used to create a container that uses
nginx and PHP 7.1 to host WebCalendar.

Use the `docker_setup.sh` script to perform the one-time setup
and configuration of the container.
The script will also startup the container.  Note that it can take 5
or so minutes for all the services of the container to be configured
on the initial startup.

The WebCalendar files and the SQLite database are shared from your
local filesystem to the container.  So you can safely destroy the
container at any time without losing data.  If you're a developer,
you can just edit the files locally in the `webcalendar` directory.

To stop the docker container:

    docker stop webcalendar-php7

To start the docker container:

    docker start webcalendar-php7

To get shell access to your container:

    docker exec -ti webcalendar-php7 /bin/sh

WebCalendar can be accessed at: http://localhost:8080/webcalendar
