Feature: Email Confirmation
  Describes the Email Confirmation behavior, which sends an email
  to a new user with a link to confirm their account. The account
  cannot be used until confirmation has been received.
  
  Background:
    Given I am using the following behaviors: "core, remember_me, email_confirmation"
  
  Scenario: Sign up
    Given I am on the homepage
      And I follow "Sign up"
    When I fill in "Email" with "generic@example.com"
      And I fill in "Password" with "Generic12"
      And I fill in "Password confirmation" with "Generic12"
      And I press "Sign up"
    Then show me the response
    Then I should receive an email
    
    When I open the email
    Then I should see "confirm" in the email body
    
    When I follow "confirm" in the email
    Then I should see "Confirm your new account"
    
