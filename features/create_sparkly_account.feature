Feature: Create an account using Sparkly Auth
  
  Scenario: Create account with valid details
    Given I am on the new user page
    When I enter new user details
    Then I should see "account has been created"

  Scenario: Create account with missing password
    Given I am on the new user page
    When I fill in "Email" with "generic@example.com"
    Then I should not see "account has been created"
    