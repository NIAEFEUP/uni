All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2023-02-13

### Added

- Forgot password link in login page
- Faculty restaurants page
- Library occupancy page
- Shimmer effect on loading screens
- School calendar page
- Possibility to hide exams

## [1.4.0] - 2022-09-19

### Added

- Clickable contact cards
- Useful Contacts Page
- User faculty storage in shared preferences
- Send bug reports and app crashes details to Sentry
- Clickable checkbox rows
- Fetch restaurants from sigarra and stored locally
- Dropdown to choose the student's faculty in the login page
- Calendar button to add an event to the calendar with the details of a exam
- Drag icon appears on widgets during editing mode
- Application dark theme
- Fetching of Terms and Conditions
- A dialog to create MB references to add money to print balance
- Course average grade and finished ects on the profile page
- Course units listing for all years with results
- Faculty locations

### Fixed

- Fix inconsistency in lecture display
- Fix possible duplicated exams during parsing
- Fix Github issues header changes
- Fix Lecture data coming from Sigarra's API
- Fix Bus Stops departures, to obtain new CSRF for the API
- Fix card title not occupying full width
- Fix special exams showing

### Changed

- Updated Android's `targetSdkVersion` to 30
- Changed the Checkbox background to dark red
- Changed 'Paragens' to 'Autocarros'
- Changed Exam's constructor
- Limited widget dragging to within editing mode

## [1.1.0] - 2021-04-18

### Added

- Customizable filtering of displayed exams
- Optionally view password when inserting it on login page
- Class number in schedule lectures
- Highlighting most relevant exams

### Changed

- Fixed bus schedule not working (switched API)
- Fixed issue in timestamp display
- Add fallback when fetching schedules to deal with API inconsistency
- Fix exams disappearing on exam day
- Schedule page now updates as expected
- Other minor bugs fixed

## [1.0.0] - 2020-03-01

### Added

- Schedule page and widget
- Exams page and widget
- Profile page with basic user information
- Printing Quota widget
- Live bus schedules of the Porto area
