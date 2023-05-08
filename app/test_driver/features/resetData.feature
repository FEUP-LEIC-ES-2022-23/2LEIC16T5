Feature: Reset Data

	Background:
		Given the user is in the "Settings" menu

	Scenario: User accidentally pressed the “Reset Data” button
		Given the user presses the "Reset Data" button
		When the user presses the "No" button
		Then the user is in the "Settings" menu

	Scenario: User wishes to reset the data inserted into the app
		Given the user has inserted data into the app
		And the user presses the "Reset Data" button
		When the user presses the "Yes" button
		Then a "Your data has been successfully deleted" message is shown

	Scenario: No data has been inserted into the app
		Given the user presses the "Reset Data" button
		When the user presses the "Yes" button
		Then a "No data has been inserted into the app" message is shown
