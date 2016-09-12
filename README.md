# [Hi](#hi)

Docker! Shell scripts that branch and do things!

This repository exists to establish the required configuration settings for our docker stack to be used in development
and test for Waypoint. At this stage the solution is not considered appropriate for staging or prod.

The tech stack required will initially just be the api.

# [Goals](#goals)

The goals are twofold.

**Firstly**, a new developer on the project should be able to:

1. clone the git repo
1. run the setup script
1. following any instructuions if necessary, an environment should be available

Then, and for regular developers on the project, the development process should be as seamlesss as:

1. `git pull`
1. `docker compose up -d`
1. any gem interactions run like: `docker compose run api bundle install`
1. any database interactions run like: `docker compose run api bundle exec bin/rails db:migrate`
1. specs run like: `docker compose run api bundle exec bin/rspec spec`
1. use normal git workflow (feature branches, PRs etc)

**Secondly**, we should have an isolated test env that can be deployed using a CI tool (ie. Buildkite) that "just works"
and matches our dev env (so test behaviour is predictable).

For this, we will use a Buildkite account that has a pipeline that executes a script that (conditionally, if required)
sets up the test environment for docker and runs `docker compose run qpi bundle exec bin/rspec spec`. This pipeline
will be executed by a Buildkite agent that is running on the same linux box that will execute the tests. This box will
require a GitHub account with ssh key access and permission to pull code from the relevent repo(s).

The exact implementation is yet to be decided, but the pipeline might run based on a webhook with certain rules. For
example, the testing pipeline might run after any push to the master branch.

Finally, though not worthy of an explicit goal, it is noted that the managing and extending the devops process, ie
docker itself and associated scripts, should be low overhead for this to be worth doing. Obviously the tool should
support the architecture and no architectural decisions should be made to accomodate the tool in any way that might
influence the solution in prod.

# [Strategy](#strategy)

We want to run our api app in a [Docker container](https://docs.docker.com/engine/understanding-docker/), accessing
services in parallel containers linked together with [Docker Compose](https://docs.docker.com/compose/).

We will use a data volume to provide the contents of the app folder from the local dir to the api container. We will
use a data volume linked to globally installed gems on the local file system to effectively cache gems in order to
avoid installing all gems from scratch every time `bundle _______` needs to run.

# [Use Of Images](#use-of-images)

Official Docker images exist for all the major technologies we want to use.

The "main" or controlling docker image will be an image that contains the environment for our rails api. This image will
be based on the [official Ruby image](https://hub.docker.com/_/ruby/ "Docker Official Ruby Image") modified to contain
configuration specific to our application.

We will also use the [Postgres image](https://hub.docker.com/_/postgres/ "Docker Official Postgres Images") and
the [Redis image](https://hub.docker.com/_/redis/ "Docker Official Redis Images").

To see what is in each of these images, refer:

- https://github.com/docker-library/ruby/blob/2d6449f03976ededa14be5cac1e9e070b74e4de4/2.3/Dockerfile
- https://github.com/docker-library/postgres/blob/fc36c25f8ac352f1fea6d0e7cf8d9bd92a4e720f/9.5/Dockerfile
- https://github.com/docker-library/redis/blob/71807ba24f85da5bc14e9251da3617bbb6f47146/3.2/Dockerfile

and for the chain of images they are ultimately based on:

- https://github.com/docker-library/buildpack-deps/blob/f1d33d5c92e1bd2aee9f2333ceb316251e6388d4/jessie/Dockerfile
- https://github.com/docker-library/buildpack-deps/blob/1845b3f918f69b4c97912b0d4d68a5658458e84f/jessie/scm/Dockerfile
- https://github.com/docker-library/buildpack-deps/blob/a0a59c61102e8b079d568db69368fb89421f75f2/jessie/curl/Dockerfile
- https://github.com/tianon/docker-brew-debian/blob/589b967ff4364528ebd686b002a6ee00f00f4657/jessie/Dockerfile

# [Notes](#notes)

Since we will be using a linux box (presumably virtual, hosted on AWS) for our CI, we are presently limited to the
linux supported version of Docker Compose, which is 1.5.2 as of the time of writing (12/09/16). This version, unlike 1.6+
only supports "version 1" of the docker-compose.yml syntax.

# [Unanswered Questions](#unanswered-questions)

**What are the logging implications?**

**What is required to include passenger in the setup?**

**My server run is failing with "server is already running. Check /api/tmp/pids/server.pid." Help?**

*Not sure if this will still happen when we set up with passenger so haven't looked into a permanent fix. For now, just `rm sweet_app/api/tmp/pids/server.pid`*

# [TODO](#todo)
- we want two(?) pipelines: set up pipeline, test pipeline? or just a smarter pipeline that figures it out with a
  shell script?
