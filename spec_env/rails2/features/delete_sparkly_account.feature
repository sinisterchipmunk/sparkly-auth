Feature: delete sparkly account
  
  Scenario: not logged in
    When I delete my account
    Then I should see "You must be signed in to view this page."
    
  Scenario: logged in
    Given I am logged in
    When I delete my account
    Then I should see "Your account has been deleted."
      And I should not be logged in
    