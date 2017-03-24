# Change Log

All notable changes to this project will be documented in this file.
## [Unreleased]

### Added
- Added a features document for Release 2.
- Parser now reports unnamed PML constructs. These are then displayed to the
  user in a similar manner to other warnings.
- Parser now reports PML construct name clashes. These are then displayed to the
  user in a similar manner to other warnings.

### Fixed
- Running automated integration tests will now correctly test the release
  matching the current tag that is checked out.

## [1.1] 2017-03-19

### Added
- Added support for PML TX file downloads. Valid pml files uploaded to the
  system for transformation can now be downloaded via the UI.

## [1.0] 2017-03-12

### Changed
- Clarified installation instructions after feedback from client. Client left
  feedback after release 0.3 indicating that our current README was unhelpful.
  We have greatly simplified it and moved more non-essential information into
  separate documents.
- Updated user interface with loading icon to provide visual representation of
  the request's duration.
- Changed the homepage to update when a file is selected not when it is
  analysed, based on client feedback.
- Updated the representation of drugs in PML after client feedback. Our initial
  representation meant that users had to look up the CHEBI/DINTO identifier for
  a drug. Now users can specify drugs with a new `drug { "name" }` construct.
- Added UI section to display drugs that were specified in the PML but that are
  not included in DINTO
- Updated user interface to enable live updates in which the results of the
  PML parsing and DINTO lookup are displayed as soon as they are found before
  the DDIs have been calculated
- Updated how analysis results are displayed to make them more readable.
  Previously we would display the JSON responses from the API to the user. Now
  we take the JSON responses and create a readable message which is then
  displayed to the user.
- Updated the testing instructions. The client indicated that he would like
  clear instructions for manual acceptance tests. We have updated the testing
  instructions in `FEATURES.md` accordingly. We also removed references to
  Panacea's automated unit tests. A section was added about running our new
  end-to-end tests instead, as these are a much more thorough test of the
  system.

### Added
- install-docker.sh for easy docker installation on Ubuntu 16.04. Part of
  simplifying the installation steps.
- Created Athloi: This service runs our end to end Cucumber tests using Selenium WebDriver
  and Firefox. This service also runs during continuous integration to ensure
  there are no regressions to the end user interface between commits/releases.

### Fixed
- Fixed a bug where analysis requests would time out.
- Fixed bug where results of the previous DDI analysis would not be cleared
  in the event there was an error with the current analysis

## [0.3] 2017-03-05

### Added
- Created Chiron: a new service for Querying DINTO built
  with [Apache Jena](https://jena.apache.org/). DINTO is turned into a triple
  store at compile time, so boot time is greatly improved. Similarly, query
  times are much improved by the triple store
- DDI analysis is now presented to users. After validating a PML file, Panacea
  queries Asclepius to find any DDIs between drugs in the file. This is then
  displayed to the user in the UI.

### Removed
- DINTO from Asclepius. Chiron houses DINTO data now. Asclepius now proxies
  queries to Chiron.
- Removed code that waited for DINTO to be loaded. Previously, Asclepius would
  take several minutes to load DINTO into memory so Panacea would have to poll
  it to see if it was ready. Chiron can load DINTO from its triple store
  instantly, so the waiting is no longer required.

## [0.2] 2017-02-26

### Added
- docker-compose. As we now have more than one docker service docker-compose is
  used to easily coordinate them. docker-compose can be installed as per the
  installation instructions in the README
- Panacea: a new docker service that is responsible for validating PML and
  serving the UI. The UI is a web app
- Parser for PML. Added a custom lexer and parser for PML. Panacea will expose a
  HTTP API for uploading files to be parsed.
- [Continuous Integration testing](https://circleci.com/gh/tom-and-the-toothfairies/pathways).
  Automated testing has been added. CI runs whenever a commit is pushed. Merging
  into master and our iteration branches requires CI to pass.
- Asclepius: a new service for querying DINTO. This service loads DINTO into
  memory when it boots and exposes a HTTP API for making queries. Panacea will
  use this API to provide users with DDI feedback.
- PML upload. Added a form that allows users to upload a file. The file is sent to Panacea for analysis.
- PML error & warning highlights. The results of file analysis are now reported back to the user.
- Asclepius DDI endpoint. Asclepius now exposes an endpoint that takes a list of
  drugs and returns any DDIs between those drugs.

### Removed
- Removed Pathways. The old docker service that
  contained [peos](https://github.com/jnoll/peos) has been removed. It is
  replaced by Asclepius and Panacea.
- Removed submodules. Previously Pathways used submodules as part of its docker
  build process. Now Asclepius clones DINTO and checks out a specific revision
  instead.


## [0.1] 2017-02-12

### Fixed
- Fixed installation instructions. Added a workaround for a DNS issue on the TCD network.

### Added
- Instructions on how to run docker without sudo on Ubuntu.

## [0.0] 2017-02-05

### Added
- Peos submodule. For now we'll use Peos to interact with PML. This will
  probably be replaced by a custom parser later as we really only need the
  parsing.
- DINTO submodule. The project depends
  on [DINTO](https://github.com/labda/DINTO) to provide information about
  drug-drug interactions (DDIs)
- Dockerfile for building project. At the moment, the project consists of one
  docker service: pathways.
- Installation instructions in README

[Unreleased]: https://github.com/tom-and-the-toothfairies/pathways/compare/1.1...iteration-6
[1.1]: https://github.com/tom-and-the-toothfairies/pathways/compare/1.0...1.1
[1.0]: https://github.com/tom-and-the-toothfairies/pathways/compare/0.3...1.0
[0.3]: https://github.com/tom-and-the-toothfairies/pathways/compare/0.2...0.3
[0.2]: https://github.com/tom-and-the-toothfairies/pathways/compare/0.1...0.2
[0.1]: https://github.com/tom-and-the-toothfairies/pathways/compare/0.0...0.1
[0.0]: https://github.com/tom-and-the-toothfairies/pathways/compare/faf0500c792aebbee26541ea2c25ad6ae274b2d5...0.0
