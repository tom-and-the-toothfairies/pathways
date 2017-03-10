Feature: File selection
  In order to perform PML analysis
  As a clinician
  I should be able to select PML files

  Scenario: selecting a file
    Given I am on the home page
    When I select "ddis.pml"
    Then I should see "ddis.pml" in the file input
