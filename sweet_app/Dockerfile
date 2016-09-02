# TODO:can we handle some error cases? if this image is not run with a mounted /api for example?
# also we will need to exit n where config etc isn't in place, with messages
# probably use a bash script, so we don't have to have 37 image layers or \
#                                                                    like \
#                                                                   heaps \
#                                                                     of &&
#                                                                    this \
#                                                                  business

### BASE IMAGE
FROM ruby:2.3.1

# TODO: CHECK CONFIG is in place?
# also check secrets/env variables are in place?

### PREPARE SYSTEM FOR RAILS
# from the docker docs "Getting Started With Rails section"
# TODO: hmm do we need nodejs since it's api only?
# scattered about the place I see other inclusions for nokogiri also - we aren't using that though
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

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

### SET UP BITCOIN MINING ALGO
# jokes
# just make sure that we can see things happening on the build
# "RUN" stuff actually creates a new layer of the container, and gets run exactly once, on create
RUN ["echo", "build proceeding"]

### PRETTY GEMS
RUN bundle install

# TODO: any database commands?
# TODO: start passenger

# test yo
RUN mkdir wat && pwd && ls -al

# the CMD thing here is a default arg to run whenever the container is run
CMD ["ruby", "script.rb"]
