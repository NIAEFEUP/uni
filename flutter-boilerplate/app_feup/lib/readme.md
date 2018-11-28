# Project-Schrodinger

## Overall structure

For this project we are going to be using a more **MVC** (Model, View, Controller) architecture.
This means that, separated in three folders/packages we have Widgets for user interaction (display information, overall design, etc),
files for storing the application's state and files for fetching, handling and processing information.
This allows us to reuse widgets whenever we want the same experience for the user. It also makes it easier to change code without altering the other aspects of the app

App pages stay outside the 3 folders as they link them together

## View

The View part of the app is made of Widgets (stateful or stateless). They each should deal with their own responsibility (display and/or gather information) and any changes to the overall app should be passed up to their parents (using callbacks) until they reach the current page's widget, where the information will be handled.
**Note:** if a widget's responsibility includes handling information (for example, a date-picking widget that transforms the user input into a date format), it should be done within the widget itself.

## Model

In the Model folder, we should have the state of the app as well as the actions triggered by user input. For example, if a user changed the font-size of an application, we would call a method inside the Model (here called action) which would then use methods in Controller to process and update the application state.