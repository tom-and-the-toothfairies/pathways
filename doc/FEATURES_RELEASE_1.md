# Features

Each deliverable feature for Release 1 is outlined in this file. Each feature
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

## PML File Selection - Complete

### Description
The system allows users to upload PML files for analysis. Users must be able to
select these files from their local file system.

### Testing
Visit the [homepage]. Click the `Choose File` button and select a file
(`panacea/test/fixtures/ddis.pml` for example). The name of the chosen file
should be displayed beside the file selection button. If you have selected the
file suggested above, you should see `ddis.pml`.

## PML File Loading - Complete

### Description
Once a file has been selected, users must be able to load it into the system for analysis.

### Testing
Visit the [homepage] and select a file. Press the `Submit` button. The file
should be sent to the system, and analysis results should now be displayed. For
example, if you submit `panacea/test/fixtures/no_ddis.pml`, the analysis results
should list `paracetamol` and `cocaine` as drugs found in the file.


## Running PML Analysis - Complete

### Description
When a file is submitted, the system must analyse it. The system must ensure
that it is a valid PML file. Invalid files must be rejected, and information
about the encountered error must be readily available.

### Testing
Visit the [homepage] and select a file. Press the `Submit` button. The file
should be sent to the system, and analysis results should now be displayed.
Invalid files should result in an error dialogue, which displays a meaningful
error message. For example, `panacea/test/fixtures/bad.pml` should result in a
`Syntax error` being displayed when submitted. Valid files should result in a
success dialogue. See [PML File Loading](#pml-file-loading---complete) for an
example.

## On-Screen PML Reporting - Complete

### Description
The results of analysing a file must be made available to the user. Any errors
must be easily identified, and the error messages must be useful.

### Testing
Visit the [homepage] and select a file. Some useful files can be found in the
[fixtures directory]. Press the `Submit` button. Analysis results should be
displayed. `panacea/test/fixtures/example.png` is not UTF-8 encoded and should
result in an `Encoding error`. `panacea/test/fixtures/bad.pml` contains invalid
PML and should result in a `Syntax error`. `panacea/test/fixtures/ddis.pml`
contains valid PML and should result in a successful analysis.

## PML Log File Generation - Complete

### Description
The successful or unsuccessful loading of PML files into the system is output
to the console logs of the panacea service.

### Testing
First, open up the tail of the Panacea logs (the system must be running to do this):
```bash
$ sudo docker-compose logs -f panacea
```
Visit the [homepage] and select a file. Some useful files can be found in the
[fixtures directory]. Press the `Submit` button. You should see log entries
created indicating either a successful parse of the PML file and the drugs
contained in it or that an error occurred parsing the PML file and what the
error was.

## PML Error and Warning highlights - Complete

See [On-Screen PML Reporting](#on-screen-pml-reporting---complete)

## Select Specific OWL Ontology - Complete

### Description
Administrative users must have the ability to update the OWL file used as the
source of DDI information.

As described in the [README], our system builds a queryable database out of the
OWL file. This database is built into a docker image that is then deployed to
the production environment. To change the OWL file, users must be able to
specify which file should be used in the `docker build` process.

Instructions on how to specify an OWL file and releasing the new docker image
can be found [here](./UPDATING_DINTO.md)


## Load Selected Ontology - Complete

See [Select specific OWL Ontology](#select-specific-owl-ontology---complete)

## Identify Drugs in PML - Complete

### Description
The system must identify drug-drug interactions between any drugs in a PML
file. To do this the system must be able to identify drugs in a given PML file.
Users can specify a drug using the following construct:

`drug { "drug_name" }`

Drugs to be administered to patients must be placed in `requires` blocks within
the PML document. For example

```
process foo {
  task bar {
    requires { drug { "paracetamol" } }
  }
}
```

When a PML file is successfully analysed, any drugs found in `requires` blocks
must be reported back to the user as `identified drugs`.

### Testing
This feature can be tested by uploading files. Some useful files can be found in
the [fixtures directory]. Visit the [homepage], select a file, then press
`Submit`.

`no_ddis.pml` is a well-structured PML document containing some drug identifiers
and analysing it should result in `paracetamol` and `cocaine` being identified
and presented in the UI.

`no_drugs.pml` is a well-structured PML document that does not contain drug
identifiers. Analysing it should result in no drugs being identified.

## Identify Drugs in DINTO - Complete

### Description
The system must be able to translate drug names as described by a clinician in
plain English into a format that can be used when querying DINTO.

### Testing
This feature can be manually tested by uploading files.

Visit the [homepage] and select a PML file that contains drugs; for example
`panacea/text/fixtures/no_ddis.pml`. Press the `Submit` button. You should see
that "cocaine" and "paracetamol" have been identified as drugs in DINTO. Testing
`panacea/test/fixtures/unidentifiable_drugs.pml` returns drugs that cannot be
identified in DINTO and are highlighted with a warning as a result.

## Identify DDIs - Complete

### Description
The system must identify any drug-drug interactions between drugs in the
uploaded PML files. The drug-drug interactions are contained in DINTO.

### Testing
This feature can also be manually tested by uploading files. Some useful files
can be found in the [fixtures directory]. Visit the [homepage], select a file,
then press `Submit`.

`panacea/test/fixtures/no_ddis.pml` contains drugs that do not interact.
Analysing this file should result in no DDIs being reported to the user.

`panacea/test/fixtures/ddis.pml` contains drugs that do interact. Analysing this
file should result in DDIs being reported to the user.

## On-Screen DINTO Reporting - Complete

### Description
The system must show errors and warnings on screen when loading a new ontology.

The instructions for loading a new ontology can be found in the [updating dinto]
document. As mentioned in the [updating dinto] document, loading a new ontology
requires deploying new versions of system services to production.

If there is any problem with the ontology file then the `docker build` step will fail
and print an appropriate error message. Possible causes of errors are:

- the OWL file is malformed
- the OWL file cannot be found

`docker build` is run each time a new release is released. Images that fail to
build cannot be deployed. This prevents an invalid ontology from being deployed
to production.

## DINTO Log File Generation - Complete

### Description
A record of queries made to DINTO (via Chiron/Asclepius) can be found in the
console logs of the Chiron service.

### Testing
This feature is tested manually by looking at the logs of the running sytem.

First, open up the tail of the Chiron logs (the system must be running to do this):
```bash
$ sudo docker-compose logs -f chiron
```

Visit the [homepage] and select a PML file that contains drugs; for example
`panacea/text/fixtures/ddis.pml`. Press the `Submit` button. You should see log
entries indicating that queries were made (there will be requests such as `POST
http://chiron:3030/dinto/query`) and the contents of those queries.

## DINTO Error and Warning Highlights - Complete

See [On Screen DINTO Reporting](#on-screen-dinto-reporting---complete)

[README]: ../README.md
[homepage]: http://localhost:4000
[fixtures directory]: ../panacea/test/fixtures
[updating dinto]: ./UPDATING_DINTO.md
