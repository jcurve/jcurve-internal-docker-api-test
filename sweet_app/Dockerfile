### BASE IMAGE
FROM ruby:2.3.1

### MOVE INTO THE API VOL SO WE CAN DO THINGS
# move into the mounted volume with the app - does this make sense given it's not mounted yet?
#
# this seems a bit dank but apparently you can copy from the local dir into the container to get
# access to contents (eg. Gemfile for bundle install) then just overwrite the container dir
# using volumes on run, for example as specified in the compose yml file.
#
# This doesn't seem nice but from what I understand, it's the recommended approach ¯\_(ツ)_/¯
# refer: https://docs.docker.com/compose/faq/#/should-i-include-my-code-with-copy-add-or-a-volume
COPY . /api
WORKDIR /api

### ENSURE .env FILE IS PRESENT
RUN ["test", "-e", "./.env"]

### UPDATE SYSTEM AND INSTALL C LIB FOR CONNECTING TO PG DB AND NODEJS FOR RUNTIME
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

### GET ALL OF THE GEMS
RUN ["bundle", "install"]

RUN ["echo", "wat"]

### I <3 DATABAE
#RUN ["rails", "db:setup"]

# TODO: what about tests?

# the CMD thing here is a default arg to run whenever the container is run
CMD ["rails s"]
# this should really be:
# TODO: start passenger
