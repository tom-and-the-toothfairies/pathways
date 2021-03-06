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
    And I click the warnings tab
    Then I should see the unidentified drugs panel
    And I should see "2" in the warning number badge
    And I should see the following drugs in the unidentified drugs panel:
      | marmalade           |
      | dimethylheptylpyran |

  Scenario: uploading a PML file with no drugs
    When I select "no_drugs.pml"
    And I submit the upload form
    Then I should see the error panel
    And I should see "1" in the error number badge
    And the error panel title should be "Pathway error"

  Scenario: uploading a PML file with syntax errors
    When I select "bad.pml"
    And I submit the upload form
    Then I should see the error panel
    And I should see "1" in the error number badge
    And the error panel title should be "Syntax error"

  Scenario: uploading a PML file containing delays
    When I select "delays.pml"
    And I submit the upload form
    Then I should see the found DDIs panel

  Scenario: uploading a PML file with invalid delay timings
    When I select "bad_delays.pml"
    And I submit the upload form
    Then I should see the error panel
    And the error panel title should be "Syntax error"

  Scenario: uploading a PML file with unnamed constructs
    When I select "analysis/unnamed.pml"
    And I submit the upload form
    And I click the warnings tab
    Then I should see the unnamed panel
    And I should see "1" in the warning number badge
    And I should see the following warnings in the unnamed panel:
      | task on line 2 |

  Scenario: uploading a PML file with clashing construct names
    When I select "analysis/clashes.pml"
    And I submit the upload form
    And I click the warnings tab
    Then I should see the clashes panel
    And I should see "2" in the warning number badge
    And I should see the following warnings in the clashes panel:
      | action clash1 on line 2 |
      | action clash1 on line 9 |
      | action clash2 on line 5 |
      | action clash2 on line 7 |

  Scenario: uploading a binary file
    When I select "example.png"
    And I submit the upload form
    Then I should see the error panel
    And I should see "1" in the error number badge
    And the error panel title should be "Encoding error"

  Scenario: uploading a PML file with identifiable drugs that have an interaction
    When I select "ddis.pml"
    And I submit the upload form
    Then I should see the found DDIs panel
    And I should see the following DDIs in the found DDIs panel:
      | torasemide on line 8 and trandolapril on line 17 |

  Scenario: uploading a PML file with identifiable drugs that don't have an interaction
    When I select "no_ddis.pml"
    And I submit the upload form
    Then I should see the found DDIs panel
    But I should not see any DDIs in the found DDIs panel
