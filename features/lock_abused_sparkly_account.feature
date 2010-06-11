Feature: Lock abused sparkly accounts
  
  Scenario: Lock a user out of a sparkly account after too many failures
    Given I am on the new user session page
    When I fail to log in 5 times
    Then I should see "Account is locked due to too many invalid attempts"
    