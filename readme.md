# Project-Schrodinger

## Overall structure

For this project we are going to be separating the code into View and Controller.
By making sure view-only components are clear from the rest of the code, we can assure safe reuse of widgets as well as separated testing and development.
App pages stay in the root folder as they View and Controller together. They should only have their state and very high-level widgets. They use the code in "Controller" to update their state using the user's input.


## View

The View part of the app is made of Widgets (stateful or stateless). They each should deal with their own responsibility (display and/or gather information) and any changes to the overall app should be passed up to their parents (using callbacks) until they reach the current page's widget, where the information will be handled.
**Note:** if a widget's responsibility includes handling information (for example, a date-picking widget that transforms the user input into a date format), it should be done within the widget itself.


## Controller

In the controller folder we should only have classes and methods that process information - Dart only.
The networking side of the app will be in here, as well as the parsers.
Subfolders are crucial to keep the code organized.