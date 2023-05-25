Feature: Press Transaction

  Background:
    Given the user is in the "Transactions" menu
    And the user has inserted data into the app

  Scenario: Transaction is pressed
    When the user taps the "Expense"
    Then the user sees the "Transaction Info"
    And the user sees the "Name"
    And the user sees the "Total"
    And the user sees the "Date"

  Scenario: Transaction is long pressed
    When the user long presses the "Expense"
    And the user presses the "Yes" button
    Then a "Transaction successfully deleted!" message is shown