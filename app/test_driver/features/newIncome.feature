Feature: Manually register new income

  Rule: "Total" field must be filled in
    Background:
      Given the user is in the "Transactions" menu
      And the user presses the "Plus" button

    Scenario: Valid registration of income
      Given the user selects "Income" option
      And the user "correctly fills" in "Total" field - ex: "2304"
      When the user presses the "Add" button
      Then the user is in the "Transactions" menu
      And the user sees the "Transaction"

    Scenario: Invalid registration of income - "Total" field is not filled in
      Given the user selects "Income" option
      And the user "doesn't fill" in "Total" field - ex: ""
      When the user presses the "Add" button
      Then a "Enter an amount" message is shown

    Scenario: Invalid registration of income - attempt to insert a negative value in "Total" field
      Given the user selects "Income" option
      And the user "incorrectly fills" in "Total" field - ex: "-2304"
      When the user presses the "Add" button
      Then a "Enter a positive amount" message is shown