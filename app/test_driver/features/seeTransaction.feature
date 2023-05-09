Feature: See more information about a transaction

  Background:
    Given the user is in the "Transactions" menu
    And the user has inserted data into the app

  Scenario: Transaction is tapped
    When the user taps the "Transaction"
    Then the user sees the "Transaction Info"
    And the user sees the "Name"
    And the user sees the "Total"
    And the user sees the "Date"
