Feature: Log in

  Rule: User needs to have an account
    Background:
      Given the user is in the "Login" menu

    Scenario: The user logs in with correct credentials
      Given the user "correctly fills" in "Email" field - ex: "fortuneko.esof@gmail.com"
      And the user "correctly fills" in "Password" field - ex: "Fortuneko2023"
      When the user presses the "Sign in" button
      Then the user is in the "Main" menu

    Scenario: The user tries to log in with wrong email
      Given the user "incorrectly fills" in "Email" field - ex: "fortuneko@gmail.com"
      And the user "correctly fills" in "Password" field - ex: "Fortuneko2023"
      When the user presses the "Sign in" button
      Then the user is in the "Login" menu

    Scenario: The user tries to log in with wrong password
      Given the user "correctly fills" in "Email" field - ex: "fortuneko.esof@gmail.com"
      And the user "incorrectly fills" in "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then the user is in the "Login" menu

    Scenario: The user tries to log in with no email
      Given the user "(in)correctly fills" in "Password" field - ex: "123456"
      When the user presses the "Sign in" button
      Then a "Email address is required!" message is shown

    Scenario: The user tries to log in with no password
      Given the user "(in)correctly fills" in "Email" field - ex: "fortuneko@gmail.com"
      When the user presses the "Sign in" button
      Then a "Password is empty!" message is shown

    Scenario: The user tries to log in with wrong email format
      Given the user "invalidly fills" in "Email" field - ex: "fortuneko"
      When the user presses the "Sign in" button
      Then a "Invalid email address format!" message is shown