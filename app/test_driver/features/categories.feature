Feature: Category creation/assignment

  Background:
    Given the user is in the "Categories" menu

  Scenario: Valid creation of category
    Given the user presses the "Plus" button
    And the user "fills" in "Name" field - ex: "Test"
    And the user selects a color
    When the user presses the "Add" button
    Then the user is in the "Categories" menu
    And the user sees the "Test"

  Scenario: Valid creation of category with same name but different color
    Given the user presses the "Plus" button
    And the user "fills" in "Name" field - ex: "Test"
    And the user selects a different a color
    When the user presses the "Add" button
    Then the user is in the "Categories" menu
    And the user sees the "Test"

  Scenario: Invalid creation of category - "Name" field is not filled in
    Given the user presses the "Plus" button
    And the user "doesn't fill" in "Name" field - ex: ""
    When the user presses the "Add" button
    Then a "Please enter category name" message is shown

  Scenario: Category is long pressed
    When the user long presses the "Test"
    And the user presses the "Yes" button
    Then a "Category successfully deleted!" message is shown

  Scenario: Default category is long pressed
    When the user long presses the "Default"
    Then a "The Default category can't be deleted" message is shown