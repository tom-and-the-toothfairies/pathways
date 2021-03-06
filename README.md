# Tom and the Toothfairies
[![spacemacs badge]][spacemacs github] [![build status badge]][circle ci]

*Note: this document is written in Markdown. While it can be easily read in a
text editor, we recommend viewing our documentation [on
Github](https://github.com/tom-and-the-toothfairies/pathways#readme) for
maximum convenience - click-able links for example*

This file contains instructions on how to install and run the project, as well
as an overview of the project's design. The target platform is Ubuntu 16.04.

At the time of writing the current release is `2.0`

## Installing Dependencies

This project uses Docker and Docker Compose. An installation script,
`install-docker.sh`, is provided for Ubuntu 16.04.

```bash
$ ./install-docker.sh
```

For platforms other than Ubuntu, follow the installation instructions on
the [Docker Website][install docker ce]. Note - on other platforms, sudo is not
required for Docker commands.

You can test your Docker installation by running Docker's built in hello-world:

```bash
$ sudo docker run hello-world
```

## Running

The project can be run with Docker Compose:

```bash
$ sudo docker-compose up -d
```

The system is then accessible at [localhost:4000](http://localhost:4000).

To stop the system, run the following command

```bash
$ sudo docker-compose down
```

## Features

### Release 2

The feature list for `Release 2` can be found [in the Release 2 features
document](./doc/FEATURES_RELEASE_2.md).

### Release 1

The feature list for `Release 1` can be found [in the Release 1 features
document](./doc/FEATURES_RELEASE_1.md).

## Change Log

Changes to the project are recorded in the [change log](./doc/CHANGELOG.md).

## Architecture Overview

The system is split into three distinct services; Panacea, Asclepius and Chiron.
The auxiliary service, Athloi, is used for automated testing.
They each run inside a Docker container. The containers can be easily managed
using `docker-compose` as mentioned earlier.

### Panacea

Panacea is responsible for the UI and PML analysis. It is a web application that
serves the UI and exposes an API for uploading PML files for analysis.

More information about Panacea can be found [in the Panacea README](./panacea/README.md).

### Chiron

Chiron houses the DINTO data. The data is compiled into a triple store. Chiron
exposes a HTTP API for querying the triple store.

More information about Chiron can be found [in the Chiron README](./chiron/README.md).

### Asclepius

Asclepius acts as an intermediary between Panacea and Chiron. It accepts
requests to identify DDIs from Panacea, creates the necessary SPARQL query and
passes it on to Chiron.

More information about Asclepius can be found [in the Asclepius README](./asclepius/README.md).

### Athloi

Athloi is the service that runs our end to end tests.

More information about Athloi can be found [in the Athloi README](./athloi/README.md).

## Building Manually

Docker Compose will pull down the required versions of each service from [Docker
Hub] when you run the project. If for some reason you wish to build these
services manually, instructions for doing so can be
found [in the manual build documentation](./doc/BUILDING_MANUALLY.md).



[spacemacs badge]: https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg
[spacemacs github]: https://github.com/syl20bnr/spacemacs
[build status badge]: https://img.shields.io/circleci/project/github/tom-and-the-toothfairies/pathways/master.svg
[circle ci]: https://circleci.com/gh/tom-and-the-toothfairies/pathways
[install docker ce]: https://www.docker.com/community-edition#/download
[docker hub]:  https://hub.docker.com/u/tomtoothfairies/
