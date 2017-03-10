Feature: File upload
  In order to perform PML analysis
  As a clinician
  I should be able to upload PML files and see analysis results

  Scenario: uploading a PML file with identifiable drugs
    Given I am on the home page
    When I select "no_ddis.pml"
    And I submit the upload form
    Then I should see the found drugs panel
    And I should see the following drugs in the found drugs panel:
      | paracetamol |
      | cocaine     |

  Scenario: uploading a PML file with unidentifiable drugs
    Given I am on the home page
    When I select "unidentifiable_drugs.pml"
    And I submit the upload form
    Then I should see the unidentified drugs panel
    And I should see the following drugs in the unidentified drugs panel:
      | marmalade           |
      | dimethylheptylpyran |

  Scenario: uploading a PML file with syntax errors
    Given I am on the home page
    When I select "bad.pml"
    And I submit the upload form
    Then I should see the error panel
    And the error panel title should be "Syntax error"

  Scenario: uploading a binary file
    Given I am on the home page
    When I select "example.png"
    And I submit the upload form
    Then I should see the error panel
    And the error panel title should be "Encoding error"
