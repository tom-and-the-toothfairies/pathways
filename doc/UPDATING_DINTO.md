# Updating DINTO

This file contains instructions on how to change the OWL file used in the system.

# Background

As described in the [README], our system builds a queryable database out of the
OWL file. This database is built into a docker image (Chiron) that is then deployed to
the production environment. Within Chiron's [Dockerfile], the environment variable
`OWL_FILE` specifies which file is used.

We consider updating the ontology to be a new release of the system - as it
involves rebuilding and redeploying services. As such, the ontology can only be
updated by someone with commit access to the source code repository. This
ensures proper continuous integration and review of the change.

# Specifying a new OWL ontology

Specifying a new ontology is as simple as changing the `OWL_FILE` variable. The
variable must be a valid *URL*. The desired OWL file must be downloadable at
the specified *URL*.

# Rebuilding and Releasing new image

Once the [Dockerfile] has been updated, the changes can be committed and merged
into the master branch after passing CI and code review.

The docker images are automatically built on [Docker Hub] when a new git tag is
pushed to github. After the changes have made it into master, trigger a new
build by tagging the release. The built images are tagged with the git tag.

In production, the [docker compose file] is used to pull and start the services.
Edit the [docker compose file] and update Chiron's version number to the new tag.

The new images can then be deployed to production.

[README]: ../README.md
[Dockerfile]: ../chiron/Dockerfile
[docker compose file]: ../docker-compose.yml
[docker hub]:  https://hub.docker.com/u/tomtoothfairies/
