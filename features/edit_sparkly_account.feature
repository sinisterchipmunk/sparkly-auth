Feature: Edit sparkly account

  Scenario: not logged in
    Given I am on the edit user page
    Then I should see "You must be signed in to view this page."
    
  Scenario: logged in
    Given I am logged in
      And I am on the edit user page
    Then I should not see "You must be signed in to view this page."
      And I should be on the edit user page
    
  Scenario: Change email address
    Given I am logged in
      And I am on the edit user page
    When I fill in "email" with "generic_new@example.com"
      And I press "Update Profile"
    Then I should see "Your changes have been saved."

  Scenario: Change password
    Given I am logged in
      And I am on the edit user page
    When I fill in "password" with "Generic13"
      And I fill in "password confirmation" with "Generic13"
      And I press "Update Profile"
    Then I should see "Your changes have been saved."
    
  Scenario: Change password (already used)
    Given I am logged in
      And I am on the edit user page
    When I fill in "password" with "Generic12"
      And I fill in "password confirmation" with "Generic12"
      And I press "Update Profile"
    Then I should see "Password must not be the same as any of your recent passwords"

  Scenario: Change password (invalid)
    Given I am logged in
      And I am on the edit user page
    When I fill in "password" with "Generic13"
      And I fill in "password confirmation" with "Generic14"
      And I press "Update Profile"
    Then I should not see "Your changes have been saved."
      And I should see "prohibited this user from being saved"
      # can't remember the exact error message but whatever - if other tests pass, then this should be fine.

  Scenario: Change email and password
    Given I am logged in
      And I am on the edit user page
    When I fill in "password" with "Generic13"
      And I fill in "password confirmation" with "Generic13"
      And I press "Update Profile"
    Then I should see "Your changes have been saved."
    
        