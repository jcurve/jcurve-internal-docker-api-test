# base image
FROM ruby:2.3.1

# just make sure that we can see things happening on the build
RUN echo build proceeding

# our customisations, pinching some from this (halfway down the page):
# https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

# woa
#
