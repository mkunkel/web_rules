Feature: Home Page

  Background:
    Given a fake set of rules

  Scenario: User views the home page
    When I go to the homepage
    Then I should see "Section"
    And I should see "Subsection"
    And I should see "Header"
    And I should see "This is paragraph text"
    And I should see "Third level rule"
    And I should see "Placeholder"
    And I should not see "level1"
