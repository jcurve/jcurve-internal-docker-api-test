# NEED TO ENSURE THIS MAKES SENSE. currently planning to load the api app by mounting a data volume
# then need to do things like go into the app folder bundle install etc... but do these commands get
# executed on build rather than run? these things don't exist at that point...
#
# can we handle some error cases? if this image is not run with a mounted /api for example?
# base image
FROM ruby:2.3.1

# just make sure that we can see things happening on the build
RUN echo build proceeding

# prepare the system for rails
# from the docker docs "Getting Started With Rails section"
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# move into the mounted volume with the app - does this make sense given it's not mounted yet?
WORKDIR /api

# need to: access the app from the mounted data volume
# probably set the working directory for ease
#
# check config is in place?
# check secrets/env variables are in place?
# make sure gems are installed
RUN bundle install
# any database commands?
