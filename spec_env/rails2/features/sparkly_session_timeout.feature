Feature: Sparkly session timeout
  Scenario: Session times out
    Given I am logged in
      And my session is expired
    When I go to the edit user page
    Then I should see "You have been signed out due to inactivity. Please sign in again."
