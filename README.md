# Hi

Docker! Shell scripts that branch and do things!

This repository exists to establish the required configuration settings for our docker stack to be used in development
and test for [secret project X]. At this stage the solution is not considered appropriate for staging or prod.

The tech stack required will initially just be the api. So, we start with:

- Linux
- Ruby/Rails + Passenger
- Postgres
- Redis

# Goals

The goals are twofold.

**Firstly**, a new developer on the project should be able to:

1. clone the git repo
1. type `docker run` (or similar, ie. `docker-compose up` or whatever)
1. drink a cup of tea (pretty quickly)
1. see the app in action (with instructions)
1. party/start committing features/fixing bugs

Also, for existing developers, the development process should be as seamlesss as:

1. `git pull`
1. `docker run` or equiv.
1. basically 5 seconds later, start committing code
1. use normal git workflow (feature branches, PRs etc)

**Secondly**, we should have an isolated test env that can be deployed using a CI tool (ie. Buildkite) that "just works"
and matches our dev env (so test behaviour is predictable).

Finally, though not worthy of an explicit goal, it is noted that the managing and extending the devops process, ie
docker itself and associated scripts, should be low overhead for this to be worth doing. Obviously the tool should
support the architecture and no architectural decisions should be made to accomodate the tool in any way that might
influence the solution in prod.

# Base Images

Current docker templates to consider:

- Ruby 2.3.1: https://github.com/docker-library/ruby/blob/2d6449f03976ededa14be5cac1e9e070b74e4de4/2.3/Dockerfile
- Postgres 9.5.4: https://github.com/docker-library/postgres/blob/fc36c25f8ac352f1fea6d0e7cf8d9bd92a4e720f/9.5/Dockerfile
- Redis 3.2.3: https://github.com/docker-library/redis/blob/71807ba24f85da5bc14e9251da3617bbb6f47146/3.2/Dockerfile

NB: A common base: the ruby container uses buildpack-deps:jessie, the postgres and redis containers use debian:jessie
buildpack-deps:jessie is based on debian:jessie, but adds numerous base packages. refer:

- https://github.com/docker-library/buildpack-deps/blob/f1d33d5c92e1bd2aee9f2333ceb316251e6388d4/jessie/Dockerfile
- https://github.com/docker-library/buildpack-deps/blob/1845b3f918f69b4c97912b0d4d68a5658458e84f/jessie/scm/Dockerfile
- https://github.com/docker-library/buildpack-deps/blob/a0a59c61102e8b079d568db69368fb89421f75f2/jessie/curl/Dockerfile

and for jessie:

- https://github.com/tianon/docker-brew-debian/blob/589b967ff4364528ebd686b002a6ee00f00f4657/jessie/Dockerfile

THOUGH:
It looks like there is some overlap, but from research, the approach balancing simplicity with minimalism and safety,
plus maintainability, is to use docker compose to combine the 3 seperate containers into a single stack.

If we instead went down the path of trying to minimalize overlap and use a single container, while we reduce some
limited overlap, benefits are minimal. Disk space is cheap, but we lose the ability to rely on the official
containers managed and maintained by the ruby, postgres and redis teams.
For maintainability and reducing internal workload, composing containers from the official repositories and then
having them communicate together seems to be the way to go.

# Strategy

We will build our api app on the current Ruby base image, and use compose to connect the Redis and Postgres containers
and provide a single stack to interact with.

Additional services that we choose to add at a later stage can be added as containers to the compose script.

We will use a data volume container to provide the contents of the app folder from the local dir to the api container,
and possibly service containers if they need access. There is also the option of just providing access to the env.

The api app is basically complete composed stack, which can be later composed with the seperate front end and cdn stacks.

# Learning Process

To simulate the process required in the real repository, I will instantiate a new rails app and then dockerize it
incrementally.

# Questions

**Should we create and mount data volumes containing the app? Or just keep the code in the repo and mount the
relevant folder, ie. "mount a host directory as a data volume"?**

*The recommended solution, from Docker's documentation, is to create and mount a data volume as a container. This can
be done as a part of the compose process, then other containers that require access to data (ie. the api rails app)
can simply mount the data volume container.*

**What are the logging implications? It seems that there are some..**

*TBD*

**You are missing passenger.**

*That's not a question.*

**There seems to be another option with respect to mounting/data volumes, seems you can use docker ADD/COPY commands
to actually copy files/dirs from the working directory of the image into the image itself on build?**

*As discussed above, this seems to be an antipattern, the data would only be copied into one specific container and is
unavailable elsewhere. This makes the solution less composible.*

**How do we organise the various/multiple dockerfiles?**

*Note, we probably actually only need one custom file for the api, the front end and the CDN. Any services should be
just using the official containers for that service.*

**Are we going to store our images on dockerhub? What does that actually really mean? Why wouldn't we just use git?**

*TBD*

**Ugh how do we not bundle install from scratch errytyme?**

~~While this command gets cached and so it only matters when we need to rerun (ie. when we add a gem), this is still
annoying in that every change to the Gemfile requires a complete recreate of the docker container from the image. A
solution is posited here: http://bradgessler.com/articles/docker-bundler/~~
*So we can totally just mount a volume over the default gem path... this seems super easy. I guess we could docker/git ignore the contents if we don't want to pass stuff around, but it kinds of seems like there's not much point, as you have to download stuff from _somewhere_ on the destination machine right?*

**What the heck is with having to both provide the local dir as a data volume mounted through compose, and ALSO
adding it in the image build phase, which will get out of sync?**

*Idno it seems kind of bad through.*

**Ports?**

*Since I have postgres and redis already running, docker compose doesn't want to start containers mapping to those
ports. I guess we just choose some specific ports and run with those.*

**My server run is failing with "server is already running. Check /api/tmp/pids/server.pid." Help?**

*Not sure if this will still happen when we set up with passenger so haven't looked into a permanent fix. For now, just `rm sweet_app/api/tmp/pids/server.pid`*

# Conclusions

The final set up to use docker and buildkite for dev and CI is very simple.

The plan is detailed below:
1. Create a docker-compose.yml in the api repository.
1. Use a postgres image in compose and update the rails database.yml config, and ENV.
1. Use a redis image in compose and update the rails config(?), and ENV.
1. Create a Dockerfile in the api root folder that specifies the system dependencies for the image to run the Rails api.
1. Add a build step to the 

