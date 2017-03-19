Feature: PML Download
  In order to refine PML analysis
  As a clinician
  I should be able to download the PML file resulting from PML TX transformations

  Scenario: uploading a valid PML file
    Given I am on the home page
    When I select "ddis.pml"
    And I submit the upload form
    Then I should see the PML download button
    And the PML download button should have the correct href
