Feature: Double request
#  Some applications are having trouble reloading in development, failing with "...has been removed from the module
#tree but is still active" errors. This is an attempt to programmatically reproduce this issue.
#
#  Scenario: Reload app
#    Given I am on the new user session page
#    When I reload the application
#      And I go to the new user session page
#    Then I should not see "has been removed from the module tree but is still active!"
