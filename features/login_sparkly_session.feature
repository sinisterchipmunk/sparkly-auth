Feature: Login sparkly session
  Scenario: Valid credentials
    Given I am on the new user session page
    When I enter valid login credentials
    Then I should see "Signed in successfully."
    
  Scenario: Invalid credentials
    Given I am on the new user session page
    When I enter invalid login credentials
    Then I should see "Credentials were not valid."

  Scenario: Sign in from a page requiring authenticated access
    Given I am on the edit user page
    When I enter valid login credentials
    Then I should see "Signed in successfully."
      And I should be on the edit user page
    