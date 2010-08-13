Feature: Login sparkly session
  Background:
    Given I create an account
  
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

  Scenario: Locked due to too many failed attempts
    Given I am on the new user session page
    When I enter invalid login credentials 6 times
    Then I should see "Account is locked due to too many invalid attempts"
    
  Scenario: Log in with remember box checked
    Given I am on the new user session page
    When I check "Remember me"
      And I enter valid login credentials
    Then I should see "Signed in successfully."
      And I should have a remembrance token

  Scenario: Log in with remember box unchecked
    Given I am on the new user session page
    When I uncheck "Remember me"
      And I enter valid login credentials
    Then I should see "Signed in successfully."
      And I should not have a remembrance token
    