Feature: Category creation/assignment

  Background:
    Given the user is in the "Categories" menu
    And the user presses the "Plus" button

  Scenario: Valid creation of category
    Given the user "fills" in "Name" field - ex: "Test"
    When the user presses the "Add" button
    Then the user is in the "Categories" menu
    And the user sees the "Category"

  Scenario: Invalid creation of category - "Name" field is not filled in
    Given the user "doesn't fill" in "Name" field - ex: ""
    When the user presses the "Add" button
    Then a "Please enter category name" message is shown