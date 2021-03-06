# Features - Release 2

Each deliverable feature for Release 2 is outlined in this file. Each feature is
given a short description. For completed features, instructions on how to verify
the feature are provided.

Continuous integration testing has been set up for the project and can be
tracked on [the CI dashboard](https://circleci.com/gh/tom-and-the-toothfairies/pathways).

## End to End Automated Testing

We have developed a suite of end to end tests that verify the whole system's
functionality by automating interactions with a web browser. These can be run
from the project's root directory with the following command

```bash
$ sudo docker-compose -f docker-compose.e2e.yml -p integration run athloi; sudo docker-compose -f docker-compose.e2e.yml -p integration down
```

Our to end to end tests are written using the Cucumber
behaviour-driven-development test framework which allows tests to be written
according to user stories in plain English in the friendly "Given When Then"
format. These `feature` files can be
found [in the Athloi directory](../athloi/features).

## Manually Verifying Features

To manually verify features, run the project as outlined in the [README].
The homepage is available at [localhost:4000](http://localhost:4000).

## Mock DDI Characterisation Data - Complete

### Description

The system must provide and display mock data on DDI Harmfulness and DDI
interaction windows.

### Testing

Facilities to export this mock characterisation data as a CSV file indicating
whether an interaction is `Good`/`Bad` or an `Antagonism`/`Agonism` has been
provided by the
[Real DDI Mock Good-Bad Time Generator](#real-ddi-mock-good-bad-time-generator---complete) and
[Real DDI Mock Agonist-Antagonist Time Generator](#real-ddi-mock-agonist-antagonist-time-generator---complete) features.

This mock DDI characterisation data is displayed in the user interface. Visit
the [homepage]. Select `panacea/test/fixtures/ddis.pml` which contains a DDI.
Press `Submit`. The system should display the DDI information for the DDI found,
including whether its disposition is `Not Harmful`(Good) or `Harmful`(Bad), the
timing window and units of this timing window, as well as the drugs involved.

Specifically, it should display that the mock classification for the
torasemide/trandolapril interaction is "Harmful" and that the mock interaction
window is "2 years".

## Real DDI Mock Good-Bad Time Generator - Complete

### Description

The system must provide a means of generating mock data about the disposition of
a DDI - whether it is `Good` or `Bad`.

_A Good DDI is one which has an overall beneficial pharmacological effect._

_A Bad DDI is one which has an overall detrimental pharmacological effect._

### Testing

Enter the root of the repository. Run the command

```bash
$ ./export-mock-ddi-data.sh harmful harmful.csv
```

The file `harmful.csv` will be constructed, which can be viewed in a text
editor. The output of this command is also readily available to view in
the [mock-enriched-ddis directory](../mock-enriched-ddis/harmful.csv) of our
repository.

This is the same data that our production services use and will display to the
user.

## Real DDI Mock Agonist-Antagonist Time Generator - Complete

### Description

The system must provide a means of generating mock data about the agonism disposition of
a DDI - whether it is an `Agonism` or an `Antagonism`.

_An agonism involving `Drug 1` and `Drug 2` is a DDI such that `Drug 1` **increases** the
effect of `Drug 2`_

_An antagonism involving `Drug 1` and `Drug 2` is a DDI such that `Drug 1` **decreases** the
effect of `Drug 2`_

### Testing

Enter the root of the repository. Run the command

```bash
$ ./export-mock-ddi-data.sh agonism agonism.csv
```

The file `agonism.csv` will be constructed, which can be viewed in a text
editor. The output of this command is also readily available to view in
the [mock-enriched-ddis directory](../mock-enriched-ddis/agonism.csv) of our
repository.

This is the same data that our production services use and will display to the
user.

## Report Unnamed PML Construct - Complete

### Description

The system must identify PML constructs that are not named. The system must
display useful warning messages about such constructs to the user.

### Testing

Visit the [homepage] and select the file
`panacea/test/fixtures/analysis/unnamed.pml`. Press `Submit`. A warning should
now be visible in the warnings tab outlining the `Unnamed PML Constructs` in the
file.

Specifically, it should highlight an unnamed `task` on line `2`.

## Report PML Construct Name Clashes - Complete

### Description

The system must identify PML constructs that have the same name. The system
must display useful warning messages about such constructs to the user.

### Testing

Visit the [homepage] and select the file
`panacea/test/fixtures/analysis/clashes.pml`. Press `Submit`. A warning should
now be visible in the warnings tab outlining the `PML Construct Name Clashes` in
the file.

Specifically, it should highlight name clashes for constructs named `clash1`
and `clash2`.

## Identify Sequential DDIs - Complete

### Description
Sequential DDIs arise because the PML contains a workflow in which the
dispensing of one drug is always followed by the dispensing of another drug that
has an interaction with the first. The system should identify these sequential
DDIs and the enclosing construct.

### Testing
Visit the [homepage]. Select `panacea/test/fixtures/ddis.pml` which contains a
sequential DDI. Press `Submit`. The system should display the DDI information
for the sequential DDI found in the analysis tab including its enclosing
construct and the drugs involved.

Specifically, it should show that the torasemide/trandolapril interaction is a
sequential DDI and its enclosing construct is the task on line 2.

## Identify Parallel DDIs - Complete

### Description
Parallel DDIs arise because the PML contains interacting drugs in two different
"arms" of a PML branch construct. The system should identify these parallel DDIs
and the enclosing `branch` construct.

### Testing
Visit the [homepage]. Select `panacea/test/fixtures/parallel.pml` which contains
a parallel DDI. Press `Submit`. The system should display the DDI information
for the parallel DDI found in the analysis tab including its enclosing construct
and the drugs involved.

Specifically, it should show that the torasemide/trandolapril interaction is a
parallel DDI and its enclosing construct is the branch on line 2.

## Report Alternative non-DDIS - Complete (Bonus)

### Description
Alternative non-DDIs arise because the PML contains interacting drugs in
different "arms" of a PML selection construct. These are not DDIs but have the
potential to become DDIs if contained within an iteration construct. The system
should identify these alternative non-DDIs and the enclosing `selection`
construct. It should display them as a warning to signal potential DDIs if not
carefully handled.

### Testing
Visit the [homepage]. Select `panacea/test/fixtures/alternative_non_ddi.pml` which
contains an alternative non-DDI. Press `Submit`. The system should display the
information for the alternative non-DDI found in the analysis tab including its
enclosing construct and the drugs involved.

Specifically, it should show that the torasemide/trandolapril interaction is an
alternative non-DDI and its enclosing construct is the selection on line 2.

## Report Repeated Alternative DDIs - Complete (Bonus)

### Description
Repeated alternative DDIs arise because the PML contains interacting drugs in
different "arms" of a PML selection construct. However this selection occurs
within an iteration which may lead to an interaction when the selection is
repeated and another "arm" is chosen. The system should identify these repeated
alternative DDIs and the enclosing `selection` and `iteration` constructs.

### Testing
Visit the [homepage]. Select `panacea/test/fixtures/repeated_alternative.pml`
which contains a repeated alternative DDI. Press `Submit`. The system should
display the information for the repeated alternative DDI found in the analysis
tab including its enclosing construct and the drugs involved.

Specifically, it should show that the torasemide/trandolapril interaction is a
repeated alternative DDI and its enclosing constructs are the selection on line
3 and the iteration on line 2.

## Specify a Delay - Complete

### Description
The system should provide a way to say, at any point in a sequential workflow,
that the enactment of the pathway will pause/delay for a given time.

To represent the notion of delays, we have introduced `time` as a primitive
resource that can be used in `requires` blocks. To specify a delay, users can
add a `requires` block containing a valid `time`.

The new `time` primitive has the following format:

```
time { list of `time value`s }
```

Where a `time value` has the following format:

```
unit { duration }
```

A `duration` must be a positive integer. The supported `unit`s are:

* years
* weeks
* days
* hours
* minutes
* seconds

`time value`s can be specified in any order. Each `unit` may only appear once
within a given `time` block. The parser validates the correctness of `time`
primitives.

A simple example of a pathway containing a delay is given below:

```
process Delays {
  task TakesTime {
    action timetaker {
      requires {
        time {
          years { 20 }
          days { 15 }
          minutes { 6 }
          hours { 10 }
          seconds { 14 }
          weeks { 12 }
        }
      }
    }
  }
}
```

### Testing
Visit the [homepage] and select a file with correct timing delay information
such as `panacea/test/fixtures/delays.pml`. Press `Submit`. The system should
accept this correct file and display analysis results in the analysis tab.

Select `panacea/test/fixtures/bad_delays.pml` which contains incorrect timing
delay information. Press `Submit`. The system should display an error in the
errors tab that the `years` construct has been used more than once in a `time`
block.

## PML-TX Save PML to File - Complete

### Description
The system must be able to allow saving of transformed PML files.

### Testing
Visit the [homepage] and select a valid PML file; for example
`panacea/test/fixtures/ddis.pml`. Press the `Submit` button. You should now see
a `Save PML to file` button. Clicking the button, depending on your browser,
will either download the file automatically or prompt you to provide a filename
and location and download the file.

Note that the transformed PML file has been formatted consistently and been
stripped of comments and extra whitespace.

[README]: ../README.md
[homepage]: http://localhost:4000
[fixtures directory]: ../panacea/test/fixtures
