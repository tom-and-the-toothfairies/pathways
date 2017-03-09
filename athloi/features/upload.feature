Feature: Uploading Files
  In order to perform PML analysis
  As a clinician
  I should be able to upload PML files

  Scenario: File Name Display
    Given I am on the home page
    When I upload "ddis.pml"
    Then I should see "ddis.pml" in the file input
