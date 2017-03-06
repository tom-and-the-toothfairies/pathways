# Features

Each deliverable feature for the project is outlined in this file. Each feature
is given a short description. For completed features, instructions on how to
verify the feature are provided.

Continuous integration testing has been set up for the project and can be
tracked [here](https://circleci.com/gh/tom-and-the-toothfairies/pathways).

To manually verify features, run the project as outlined in the [README].
The homepage is available at [localhost:4000](http://localhost:4000).

## PML File Selection - Complete

### Description
The system allows users to upload PML files for analysis. Users must be able to
select these files from their local file system.

### Testing
Currently, this feature can only be tested manually. Visit the [homepage]. Click
the `Choose File` button and select a file. The chosen file should appear
as selected.

## PML File Loading - Complete

### Description
Once a file has been selected, users must be able to load it into the system for analysis.

### Testing
This feature has automated tests which can be run with the following command

```bash
$ sudo docker run -e "MIX_ENV=test" tomtoothfairies/panacea mix test --only pml_loading
```

This feature can also be tested manually. Visit the [homepage] and
select a file. Press the `Submit` button. The file should be sent to the system,
and analysis results should now be displayed.


## Running PML Analysis - Complete

### Description
When a file is submitted, the system must analyse it. The system must ensure
that it is a valid PML file. Invalid files must be rejected, and information
about the encountered error must be readily available.

### Testing
This feature has automated tests which can be run with the following command

```bash
$ sudo docker run -e "MIX_ENV=test" tomtoothfairies/panacea mix test --only pml_analysis
```

This feature can also be tested manually. Visit the [homepage] and select a
file. Press the `Submit` button. The file should be sent to the system, and
analysis results should now be displayed. Invalid files should result in an
error dialogue, which displays a meaningful error message. Valid files should
result in a success dialogue.

## On-Screen PML Reporting - Complete

### Description
The results of analysing a file must be made available to the user. Any errors
must be easily identified, and the error messages must be useful.

### Testing
This feature has automated tests which can be run with the following command

```bash
$ sudo docker run -e "MIX_ENV=test" tomtoothfairies/panacea mix test --only err_highlights
```

This feature can also be tested manually. Visit the [homepage] and select a
file. Some useful files can be found in the [fixtures directory]. Press the
`Submit` button. Analysis results should be displayed. `example.png` is not
UTF-8 encoded and should result in an `invalid filetype` error. `bad.pml`
contains invalid PML and should result in a `syntax error`. `ddis.pml` contains
valid PML and should result in a successful analysis.

## PML Log-file Generation - Complete

### Description
The successful or unsuccessful loading of PML files into the system is output
to the console logs of the panacea service.

### Testing
This feature is tested manually.

First, open up the tail of the panacea logs:
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

## Select specific OWL Ontology

## Load Selected Ontology

## Identify drugs in PML - Complete

### Description
The system must identify drug-drug interactions between any drugs in a PML
file. To do this the system must be able to identify drugs in a given PML file.
We have chosen to use CHEBI and DINTO identifiers to denote drugs in PML. These
identifiers take the form `chebi:\d+` or `dinto:DB\d+` where `\d+` is any
sequence of digits.

Drugs to be administered to patients must be placed in `requires` blocks within
the PML document. For example

```
process foo {
  task bar {
    requires { "chebi:1234" }
  }
}
```

When a PML file is successfully analysed, any drugs found in `requires` blocks
must be reported back to the user as `identified drugs`.

### Testing
This feature has automated tests which can be run with the following command

```bash
$ sudo docker run -e "MIX_ENV=test" tomtoothfairies/panacea mix test --only identify_drugs
```

This feature can also be manually tested by uploading files. Some useful files
can be found in the [fixtures directory]. Visit the homepage, select a file,
then press `Submit`.

`no_ddis.pml` is a well-structured PML document containing some drug identifiers
and analysing it should result in drugs being identified and presented in the UI.

`no_drugs.pml` is a well-structured PML document that does not contain drug
identifiers. Analysing it should result in no drugs being identified.

## Identify drugs in DINTO

## Identify DDIs - Complete

### Description
The system must identify any drug-drug interactions between drugs in the
uploaded PML files. The drug-drug interactions are contained in DINTO.

### Testing
This feature has automated tests which can be run with the following command

```bash
$ sudo docker run -e "MIX_ENV=test" tomtoothfairies/panacea mix test --only identify_ddis
```

This feature can also be manually tested by uploading files. Some usefull files
can be found in the [fixtures directory]. Visit the homepage, select a file, then press `Submit`.

`no_ddis.pml` contains drugs that do not interact. Analysing this file should
result in no DDIs being reported to the user.

`ddis.pml` contains drugs that do interact. Analysing this file should
result in DDIs being reported to the user.

## On-Screen DINTO Reporting

## DINTO Logfile Generation

## DINTO Error and Warning highlights

[README]: ./README.md
[homepage]: http://localhost:4000
[fixtures directory]: ./panacea/test/fixtures
