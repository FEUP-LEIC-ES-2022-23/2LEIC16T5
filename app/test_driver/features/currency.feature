Feature: Currency Setting

  Background:
    Given the user is in the "Settings" menu

  Scenario: Switching currency from Euro to Dollar
    Given current "currency" is "€"
    When the user selects "$" option
    Then current "currency" is "$"
    And "$" is set on the "Transactions" menu