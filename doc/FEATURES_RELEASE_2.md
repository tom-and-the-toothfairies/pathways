# Features

Each deliverable feature for Release 2 is outlined in this file. Each feature
is given a short description. For completed features, instructions on how to
verify the feature are provided.

Continuous integration testing has been set up for the project and can be
tracked [here](https://circleci.com/gh/tom-and-the-toothfairies/pathways).

## End to End Automated Testing

We have developed a suite of end to end tests that verify the whole system's
functionality by automating interactions with a web browser. These can be run
with the following command

```bash
$ sudo docker-compose -f docker-compose.e2e.yml -p integration run athloi; sudo docker-compose -f docker-compose.e2e.yml -p integration down
```

Our to end to end tests are written using the Cucumber
behaviour-driven-development test framework which allows tests to be written
according to user stories in plain English in the friendly "Given When Then"
format. These `feature` files can be found [here](../athloi/features).

## Manually Verifying Features

To manually verify features, run the project as outlined in the [README].
The homepage is available at [localhost:4000](http://localhost:4000).


## PML-TX Save PML to File - Complete

### Description
The system must be able to allow saving of transformed PML files.

### Testing
Visit the [homepage] and select a valid PML file; for example
`panacea/text/fixtures/ddis.pml`. Press the `Submit` button. You should now see
a `Download PML TX File` button. Clicking the button, depending on your
browser, will either download the file automatically or prompt you to provide a
filename and location and download the file.

[README]: ../README.md
[homepage]: http://localhost:4000
[fixtures directory]: ../panacea/test/fixtures
