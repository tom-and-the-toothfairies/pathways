# Tom and the Toothfairies
[![spacemacs badge]][spacemacs github] [![build status badge]][circle ci]

*Note: this document is written Markdown. While it can be easily read in a text
editor, we recommend viewing our documentation on
Github [here](https://github.com/tom-and-the-toothfairies/pathways#readme) for
maximum conveniece - the ability to click links for example.*

This file contains instructions on how to install and run the project, as well
as an overview of the project's design. The target platform is Ubuntu 16.04.

At the time of writing the current release is `1.1`

## Installing Dependencies

This project uses Docker and Docker Compose. For Ubuntu 16.04, an installation
script `install-docker.sh` is provided for convenience.

```bash
$ ./install-docker.sh
```

For platforms other than Ubuntu, follow the installation instructions on
the [Docker Website][install docker ce]. Note - on other platforms, sudo is not
required for docker commands.

You can test your docker installation by running docker's built in hello-world:

```bash
$ sudo docker run hello-world
```

## Running

The project can be run with `docker compose`

```bash
$ sudo docker-compose up -d
```

The system is then accessible at [localhost:4000](http://localhost:4000).

To stop the project, run the following command

```bash
$ sudo docker-compose down
```

## Features

The feature list for the project can be found [here](./doc/FEATURES.md)

## Change Log

The change log for the project can be found [here](./doc/CHANGELOG.md)


## Architecture Overview

The system is split into three distinct services; Panacea, Asclepius and Chiron.
The auxiliary service, Athloi, is used for automated testing.
They each run inside a docker container. The containers can be easily managed
using `docker-compose` as mentioned earlier.

### Panacea

Panacea is responsible for the UI and PML analysis. It is a web application that
serves the UI and exposes an API for uploading PML files for analysis.

More information about Panacea can be found [here](./panacea/README.md).

### Chiron

Chiron houses the DINTO data. The data is compiled into a triple store. Chiron
exposes a HTTP API for querying the triple store.

More information about Chiron can be found [here](./chiron/README.md).

### Asclepius

Asclepius acts as an intermediary between Panacea and Chiron. It accepts
requests to identify DDIs from Panacea, creates the necessary SPARQL query and
passes it on to Chiron.

More information about Asclepius can be found [here](./asclepius/README.md).

### Athloi

Athloi is the service that runs our end to end tests.

More information about Athloi can be found [here](./athloi/README.md).

## Building Manually

Docker compose will pull down the required versions of each service from [Docker
Hub] when you run the project. If for some reason you wish to build these
services manually, instructions for doing so can be
found [here](./doc/BUILDING_MANUALLY.md).



[spacemacs badge]: https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg
[spacemacs github]: https://github.com/syl20bnr/spacemacs
[build status badge]: https://img.shields.io/circleci/project/github/tom-and-the-toothfairies/pathways/master.svg
[circle ci]: https://circleci.com/gh/tom-and-the-toothfairies/pathways
[install docker ce]: https://www.docker.com/community-edition#/download
[docker hub]:  https://hub.docker.com/u/tomtoothfairies/
