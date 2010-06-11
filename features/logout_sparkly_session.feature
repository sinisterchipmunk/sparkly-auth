Feature: Logout sparkly session
  Scenario: when logged in
    Given I am logged in
    When I log out
    Then I should see "You have been signed out."
    
  Scenario: when already logged out
    When I log out
    Then I should see "You have been signed out."
    