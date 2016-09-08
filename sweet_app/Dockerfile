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
# for now we don't care
#COPY . /api
WORKDIR /api

### ENSURE .env FILE IS PRESENT
# TODO: check the actual environment variables presence
#RUN ["test", "-e", "./.env"]
# something like RUN  ["test", "$THING", "!=", ""] should work

### UPDATE SYSTEM AND INSTALL C LIB FOR CONNECTING TO PG DB AND NODEJS FOR RUNTIME
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

### USE EXTERNAL BUNDLE VOLUME
# for now we do this manually
#ENV BUNDLE_GEMFILE=./Gemfile BUNDLE_JOBS=2 BUNDLE_PATH=/bundle

### GET ALL OF THE GEMS
# for now we do this manually
#RUN ["bundle", "install"]

### I <3 DATABAE
# for now we do this manually
#RUN bundle exec bin/rails db:create && bundle exec bin/rails db:migrate

# the CMD thing here is a default arg to run whenever the container is run
CMD bundle exec bin/rails s -p 3000 -b '0.0.0.0'
# this should really be:
# TODO: start passenger

# What about tests? Actually, these are just a different command for the container.

