Feature: File upload
  In order to perform PML analysis
  As a clinician
  I should be able to upload PML files and see analysis results

  Background:
    Given I am on the home page

  Scenario: uploading a PML file with identifiable drugs
    When I select "no_ddis.pml"
    And I submit the upload form
    Then I should see the found drugs panel
    And I should see the following drugs in the found drugs panel:
      | paracetamol |
      | cocaine     |

  Scenario: uploading a PML file with unidentifiable drugs
    When I select "unidentifiable_drugs.pml"
    And I submit the upload form
    Then I should see the unidentified drugs panel
    And I should see the following drugs in the unidentified drugs panel:
      | marmalade           |
      | dimethylheptylpyran |

  Scenario: uploading a PML file with no drugs
    When I select "no_drugs.pml"
    And I submit the upload form
    Then I shouldn't see any panels

  Scenario: uploading a PML file with syntax errors
    When I select "bad.pml"
    And I submit the upload form
    Then I should see the error panel
    And the error panel title should be "Syntax error"

  Scenario: uploading a binary file
    When I select "example.png"
    And I submit the upload form
    Then I should see the error panel
    And the error panel title should be "Encoding error"

  Scenario: uploading a PML file with identifiable drugs that have an interaction
    When I select "ddis.pml"
    And I submit the upload form
    Then I should see the found ddis panel
    And I should see the following ddis in the found ddis panel:
      | torasemide/trandolapril DDI |

  Scenario: uploading a PML file with identifiable drugs that don't have an interaction
    When I select "no_ddis.pml"
    And I submit the upload form
    Then I should see the found ddis panel
    But I should not see any ddis in the found ddis panel
