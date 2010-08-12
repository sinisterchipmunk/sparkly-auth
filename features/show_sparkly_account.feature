Feature: Show sparkly account
  
  Scenario: While not logged in
    When I go to the show user page
    Then I should see "You must be signed in to view this page."

  Scenario: While logged in
    Given I am logged in
    When I go to the show user page
    Then I should not see "You must be signed in to view this page."
      And I should be on the show user page
      # As in, not redirected.
      
