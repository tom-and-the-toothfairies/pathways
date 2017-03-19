Feature: PML Download
  In order to refine PML analysis
  As a clinician
  I should be able to download the PML file resulting from PML TX transformations

  Background:
    Given I am on the home page

  Scenario: uploading a PML file with identifiable drugs
    When I select "ddis.pml"
    And I submit the upload form
    And I click the PML Download button
    Then I should get a download with the filename "pml-tx.pml"
