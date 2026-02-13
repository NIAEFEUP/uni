// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(type) =>
      "${Intl.select(type, {'all_dishes': 'All dishes', 'meat_dishes': 'Meat dishes', 'fish_dishes': 'Fish dishes', 'vegetarian_dishes': 'Vegetarian dishes', 'soups': 'Soups', 'salads': 'Salads', 'diet_dishes': 'Diet dishes', 'dishes_of_the_day': 'Dishes of the Day', 'closed': 'Closed', 'other': 'Other'})}";

  static m1(time) => "last refresh at ${time}";

  static m2(time) =>
      "${Intl.plural(time, zero: 'Refreshed ${time} minutes ago', one: 'Refreshed ${time} minute ago', other: 'Refreshed ${time} minutes ago')}";

  static m3(title) =>
      "${Intl.select(title, {'horario': 'Schedule', 'exames': 'Exams', 'area': 'Personal Area', 'cadeiras': 'Course Units', 'autocarros': 'Buses', 'locais': 'Places', 'restaurantes': 'Restaurants', 'calendario': 'Calendar', 'biblioteca': 'Library', 'percurso_academico': 'Academic Path', 'mapa': 'Map', 'faculdade': 'Faculty', 'other': 'Other'})}";

  static m4(period) =>
      "${Intl.select(period, {'lunch': 'Lunch', 'dinner': 'Dinner', 'other': 'Other'})}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About us"),
    "academic_services": MessageLookupByLibrary.simpleMessage(
      "Academic services",
    ),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "account_card_title": MessageLookupByLibrary.simpleMessage(
      "Checking account",
    ),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "add_photo": MessageLookupByLibrary.simpleMessage("Add photo"),
    "add_quota": MessageLookupByLibrary.simpleMessage("Add quota"),
    "add_restaurants": MessageLookupByLibrary.simpleMessage("Add restaurants"),
    "add_to_calendar": MessageLookupByLibrary.simpleMessage("Add to calendar"),
    "add_widget": MessageLookupByLibrary.simpleMessage("Add widget"),
    "agree_terms": MessageLookupByLibrary.simpleMessage(
      "By entering you agree with these",
    ),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "all_feminine": MessageLookupByLibrary.simpleMessage("All"),
    "all_widgets_added": MessageLookupByLibrary.simpleMessage(
      "All available widgets have already been added to your personal area!",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "assessments": MessageLookupByLibrary.simpleMessage("Assessments"),
    "at_least_one_college": MessageLookupByLibrary.simpleMessage(
      "Select at least one college",
    ),
    "available_amount": MessageLookupByLibrary.simpleMessage(
      "Available amount",
    ),
    "available_elements": MessageLookupByLibrary.simpleMessage(
      "Available elements",
    ),
    "average": MessageLookupByLibrary.simpleMessage("Average"),
    "balance": MessageLookupByLibrary.simpleMessage("Balance"),
    "banner_info": MessageLookupByLibrary.simpleMessage(
      "We collect anonymous usage data to help improve your experience. You can opt out anytime in the settings.",
    ),
    "bibliography": MessageLookupByLibrary.simpleMessage("Bibliography"),
    "breakfast": MessageLookupByLibrary.simpleMessage("Breakfast"),
    "bs_description": MessageLookupByLibrary.simpleMessage(
      "Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!",
    ),
    "bug_description": MessageLookupByLibrary.simpleMessage(
      "Bug found, how to reproduce it, etc.",
    ),
    "bug_description_Suggestion": MessageLookupByLibrary.simpleMessage(
      "Suggestion",
    ),
    "bug_description_error": MessageLookupByLibrary.simpleMessage("Error"),
    "bug_description_other": MessageLookupByLibrary.simpleMessage("Other"),
    "bug_description_unexpected_behaviour":
        MessageLookupByLibrary.simpleMessage("Unexpected Behaviour"),
    "bug_description_visual_detail": MessageLookupByLibrary.simpleMessage(
      "Visual Detail",
    ),
    "bus_error": MessageLookupByLibrary.simpleMessage(
      "Unable to get information",
    ),
    "bus_information": MessageLookupByLibrary.simpleMessage(
      "Select the buses you want information about:",
    ),
    "buses_personalize": MessageLookupByLibrary.simpleMessage(
      "Personalize your buses here",
    ),
    "buses_text": MessageLookupByLibrary.simpleMessage(
      "Favorite buses will be displayed in the favorites \'Bus\' widget. The remaining ones will only be displayed on the page.",
    ),
    "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "change": MessageLookupByLibrary.simpleMessage("Change"),
    "change_password": MessageLookupByLibrary.simpleMessage("Change password"),
    "change_prompt": MessageLookupByLibrary.simpleMessage(
      "Do you want to change the password?",
    ),
    "check_internet": MessageLookupByLibrary.simpleMessage(
      "Check your internet connection",
    ),
    "classProfessor": MessageLookupByLibrary.simpleMessage("Class Professor"),
    "class_registration": MessageLookupByLibrary.simpleMessage(
      "Class Registration",
    ),
    "collect_usage_stats": MessageLookupByLibrary.simpleMessage(
      "Collect usage statistics",
    ),
    "college": MessageLookupByLibrary.simpleMessage("College: "),
    "college_select": MessageLookupByLibrary.simpleMessage(
      "select your college(s)",
    ),
    "conclude": MessageLookupByLibrary.simpleMessage("Done"),
    "configured_buses": MessageLookupByLibrary.simpleMessage(
      "Configured Buses",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirm_logout": MessageLookupByLibrary.simpleMessage(
      "Do you really want to log out? Your local data will be deleted and you will have to log in again.",
    ),
    "consent": MessageLookupByLibrary.simpleMessage(
      "I consent to this information being reviewed by NIAEFEUP and may be deleted at my request.",
    ),
    "contact": MessageLookupByLibrary.simpleMessage("Contact (optional)"),
    "copy_center": MessageLookupByLibrary.simpleMessage("Copy center"),
    "copy_center_building": MessageLookupByLibrary.simpleMessage(
      "Floor -1 of building B | AEFEUP building",
    ),
    "courseRegent": MessageLookupByLibrary.simpleMessage("Course Regent"),
    "course_class": MessageLookupByLibrary.simpleMessage("Classes"),
    "course_info": MessageLookupByLibrary.simpleMessage("Info"),
    "courses": MessageLookupByLibrary.simpleMessage("Courses"),
    "current_state": MessageLookupByLibrary.simpleMessage("Current state: "),
    "current_year": MessageLookupByLibrary.simpleMessage(
      "Current academic year: ",
    ),
    "decrement": MessageLookupByLibrary.simpleMessage("Decrement 1,00€"),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "desired_email": MessageLookupByLibrary.simpleMessage(
      "Email where you want to be contacted",
    ),
    "dinner": MessageLookupByLibrary.simpleMessage("Dinner"),
    "dish_type": m0,
    "dish_types": MessageLookupByLibrary.simpleMessage("Dish Types"),
    "dona_bia": MessageLookupByLibrary.simpleMessage(
      "D. Beatriz\'s stationery store",
    ),
    "dona_bia_building": MessageLookupByLibrary.simpleMessage(
      "Floor -1 of building B (B-142)",
    ),
    "download_error": MessageLookupByLibrary.simpleMessage(
      "Error downloading the file",
    ),
    "drag_and_drop": MessageLookupByLibrary.simpleMessage(
      "Drag and drop elements",
    ),
    "ects": MessageLookupByLibrary.simpleMessage("ECTS performed: "),
    "edit_off": MessageLookupByLibrary.simpleMessage("Edit"),
    "edit_on": MessageLookupByLibrary.simpleMessage("Finish editing"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "empty_text": MessageLookupByLibrary.simpleMessage(
      "Please fill in this field",
    ),
    "evaluation": MessageLookupByLibrary.simpleMessage("Evaluation"),
    "exams": MessageLookupByLibrary.simpleMessage("Exams"),
    "exams_filter": MessageLookupByLibrary.simpleMessage(
      "Exams Filter Settings",
    ),
    "exit_confirm": MessageLookupByLibrary.simpleMessage(
      "Do you really want to exit?",
    ),
    "expired_password": MessageLookupByLibrary.simpleMessage(
      "Your password has expired",
    ),
    "fail_to_authenticate": MessageLookupByLibrary.simpleMessage(
      "Failed to authenticate",
    ),
    "failed_login": MessageLookupByLibrary.simpleMessage("Login failed"),
    "failed_upload": MessageLookupByLibrary.simpleMessage("Failed to upload"),
    "favorite_filter": MessageLookupByLibrary.simpleMessage("Favorites"),
    "fee_date": MessageLookupByLibrary.simpleMessage("Deadline"),
    "fee_notification": MessageLookupByLibrary.simpleMessage("Fee deadline"),
    "feedback_description": MessageLookupByLibrary.simpleMessage(
      "Report an issue or suggest an improvement",
    ),
    "files": MessageLookupByLibrary.simpleMessage("Files"),
    "first_year_registration": MessageLookupByLibrary.simpleMessage(
      "Year of first registration: ",
    ),
    "floor": MessageLookupByLibrary.simpleMessage("Floor"),
    "floors": MessageLookupByLibrary.simpleMessage("Floors"),
    "forgot_password": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "frequency": MessageLookupByLibrary.simpleMessage("Eligibility for exams"),
    "generate_reference": MessageLookupByLibrary.simpleMessage(
      "Generate reference",
    ),
    "geral_registration": MessageLookupByLibrary.simpleMessage(
      "General Registration",
    ),
    "goi": MessageLookupByLibrary.simpleMessage(
      "Orientation and Integration Office",
    ),
    "improvement_registration": MessageLookupByLibrary.simpleMessage(
      "Enrollment for Improvement",
    ),
    "increment": MessageLookupByLibrary.simpleMessage("Increment 1,00€"),
    "instructor": MessageLookupByLibrary.simpleMessage("Instructor"),
    "instructors": MessageLookupByLibrary.simpleMessage("Instructors"),
    "internet_status_exception": MessageLookupByLibrary.simpleMessage(
      "Check your internet connection",
    ),
    "invalid_credentials": MessageLookupByLibrary.simpleMessage(
      "Invalid credentials",
    ),
    "keep_login": MessageLookupByLibrary.simpleMessage("Remember me"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "last_refresh_time": m1,
    "last_timestamp": m2,
    "leave_feedback": MessageLookupByLibrary.simpleMessage("Leave feedback"),
    "lectures": MessageLookupByLibrary.simpleMessage("Lectures"),
    "library": MessageLookupByLibrary.simpleMessage("Library"),
    "library_occupation": MessageLookupByLibrary.simpleMessage(
      "Library Occupation",
    ),
    "load_error": MessageLookupByLibrary.simpleMessage(
      "Error loading the information",
    ),
    "loading_terms": MessageLookupByLibrary.simpleMessage(
      "Loading Terms and Conditions...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "login_with_credentials": MessageLookupByLibrary.simpleMessage(
      "Login with credentials",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "lunch": MessageLookupByLibrary.simpleMessage("Lunch"),
    "menus": MessageLookupByLibrary.simpleMessage("Menus"),
    "min_value_reference": MessageLookupByLibrary.simpleMessage(
      "Minimum value: 1,00 €",
    ),
    "multimedia_center": MessageLookupByLibrary.simpleMessage(
      "Multimedia center",
    ),
    "nav_title": m3,
    "news": MessageLookupByLibrary.simpleMessage("News"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noExamsScheduled": MessageLookupByLibrary.simpleMessage(
      "No exams scheduled",
    ),
    "noInstructors": MessageLookupByLibrary.simpleMessage(
      "No instructors assigned",
    ),
    "no_app": MessageLookupByLibrary.simpleMessage(
      "No app found to open the file",
    ),
    "no_bus": MessageLookupByLibrary.simpleMessage("Don\'t miss any bus!"),
    "no_bus_stops": MessageLookupByLibrary.simpleMessage("No configured stops"),
    "no_class": MessageLookupByLibrary.simpleMessage(
      "There are no classes to display",
    ),
    "no_classes": MessageLookupByLibrary.simpleMessage("No classes to present"),
    "no_classes_on": MessageLookupByLibrary.simpleMessage(
      "You don\'t have classes on",
    ),
    "no_classes_on_weekend": MessageLookupByLibrary.simpleMessage(
      "You don\'t have classes on",
    ),
    "no_classes_this_week": MessageLookupByLibrary.simpleMessage(
      "You have no classes this week",
    ),
    "no_college": MessageLookupByLibrary.simpleMessage("no college"),
    "no_course_units": MessageLookupByLibrary.simpleMessage(
      "No course units in the selected period",
    ),
    "no_courses": MessageLookupByLibrary.simpleMessage(
      "No courses we\'re found",
    ),
    "no_courses_description": MessageLookupByLibrary.simpleMessage(
      "Try to refresh the page",
    ),
    "no_data": MessageLookupByLibrary.simpleMessage(
      "There is no data to show at this time",
    ),
    "no_date": MessageLookupByLibrary.simpleMessage("No date"),
    "no_events": MessageLookupByLibrary.simpleMessage("No events found"),
    "no_exams": MessageLookupByLibrary.simpleMessage(
      "You have no exams scheduled\n",
    ),
    "no_exams_label": MessageLookupByLibrary.simpleMessage(
      "Looks like you are on vacation!",
    ),
    "no_favorite_restaurants": MessageLookupByLibrary.simpleMessage(
      "No favorite restaurants open",
    ),
    "no_files": MessageLookupByLibrary.simpleMessage(
      "There\'s no files attached",
    ),
    "no_files_found": MessageLookupByLibrary.simpleMessage("No files found"),
    "no_files_label": MessageLookupByLibrary.simpleMessage(
      "You have nothing to see!",
    ),
    "no_info": MessageLookupByLibrary.simpleMessage(
      "There is no information to display",
    ),
    "no_internet": MessageLookupByLibrary.simpleMessage(
      "It looks like you\'re offline",
    ),
    "no_library_info": MessageLookupByLibrary.simpleMessage(
      "No library occupation information available",
    ),
    "no_link": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t open the link",
    ),
    "no_menu_info": MessageLookupByLibrary.simpleMessage(
      "There is no information available about meals",
    ),
    "no_menus": MessageLookupByLibrary.simpleMessage(
      "There are no meals available",
    ),
    "no_name_course": MessageLookupByLibrary.simpleMessage("Unnamed course"),
    "no_news": MessageLookupByLibrary.simpleMessage("No news to display"),
    "no_places_info": MessageLookupByLibrary.simpleMessage(
      "There is no information available about places",
    ),
    "no_print_info": MessageLookupByLibrary.simpleMessage(
      "No print balance information",
    ),
    "no_references": MessageLookupByLibrary.simpleMessage(
      "There are no references to pay",
    ),
    "no_results": MessageLookupByLibrary.simpleMessage("No match"),
    "no_selected_courses": MessageLookupByLibrary.simpleMessage(
      "There are no course units to display",
    ),
    "no_selected_exams": MessageLookupByLibrary.simpleMessage(
      "There are no exams to present",
    ),
    "no_trips": MessageLookupByLibrary.simpleMessage(
      "No trips found at the moment",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "now": MessageLookupByLibrary.simpleMessage("Now"),
    "occurrence_type": MessageLookupByLibrary.simpleMessage(
      "Type of occurrence",
    ),
    "of_month": MessageLookupByLibrary.simpleMessage("of"),
    "open_error": MessageLookupByLibrary.simpleMessage(
      "Error opening the file",
    ),
    "other_links": MessageLookupByLibrary.simpleMessage("Other links"),
    "pass_change_request": MessageLookupByLibrary.simpleMessage(
      "For security reasons, passwords must be changed periodically.",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "pendent_references": MessageLookupByLibrary.simpleMessage(
      "Pending references",
    ),
    "permission_denied": MessageLookupByLibrary.simpleMessage(
      "Permission denied",
    ),
    "personal_assistance": MessageLookupByLibrary.simpleMessage(
      "Face-to-face assistance",
    ),
    "press_again": MessageLookupByLibrary.simpleMessage("Press again to exit"),
    "print": MessageLookupByLibrary.simpleMessage("Print"),
    "print_balance": MessageLookupByLibrary.simpleMessage("Print balance"),
    "prints": MessageLookupByLibrary.simpleMessage("Prints"),
    "problem_id": MessageLookupByLibrary.simpleMessage(
      "Brief identification of the problem",
    ),
    "program": MessageLookupByLibrary.simpleMessage("Program"),
    "reference_sigarra_help": MessageLookupByLibrary.simpleMessage(
      "The generated reference data will appear in Sigarra, checking account.\nProfile > Checking Account",
    ),
    "reference_success": MessageLookupByLibrary.simpleMessage(
      "Reference created successfully!",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "remaining_instructors": MessageLookupByLibrary.simpleMessage(
      "Remaining Instructors",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Delete"),
    "report_error": MessageLookupByLibrary.simpleMessage("Report error"),
    "restaurant_main_page": MessageLookupByLibrary.simpleMessage(
      "Do you want to see your favorite restaurants in the main page?",
    ),
    "restaurant_period": m4,
    "restaurants": MessageLookupByLibrary.simpleMessage("Restaurants"),
    "tomorrows_meals": MessageLookupByLibrary.simpleMessage("Tomorrow's Menu"),
    "no_menu_tomorrow": MessageLookupByLibrary.simpleMessage(
      "Tomorrow's Menu Unavailable",
    ),
    "room": MessageLookupByLibrary.simpleMessage("Room"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
    "school_calendar": MessageLookupByLibrary.simpleMessage("School Calendar"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "see_more": MessageLookupByLibrary.simpleMessage("See more"),
    "select_all": MessageLookupByLibrary.simpleMessage("Select All"),
    "semester": MessageLookupByLibrary.simpleMessage("Semester"),
    "send": MessageLookupByLibrary.simpleMessage("Send"),
    "sent_error": MessageLookupByLibrary.simpleMessage(
      "An error occurred in sending",
    ),
    "services": MessageLookupByLibrary.simpleMessage("Services"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "snackbar": MessageLookupByLibrary.simpleMessage("Snackbar"),
    "some_error": MessageLookupByLibrary.simpleMessage("Some error!"),
    "stcp_stops": MessageLookupByLibrary.simpleMessage("STCP - Upcoming Trips"),
    "student_number": MessageLookupByLibrary.simpleMessage("Student Number"),
    "success": MessageLookupByLibrary.simpleMessage("Sent with success"),
    "successful_open": MessageLookupByLibrary.simpleMessage(
      "File opened successfully",
    ),
    "tele_assistance": MessageLookupByLibrary.simpleMessage(
      "Telephone assistance",
    ),
    "tele_personal_assistance": MessageLookupByLibrary.simpleMessage(
      "Face-to-face and telephone assistance",
    ),
    "telephone": MessageLookupByLibrary.simpleMessage("Telephone"),
    "terms": MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
    "terms_change": MessageLookupByLibrary.simpleMessage(
      "Changes on uni\'s Terms and Conditions",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "try_again": MessageLookupByLibrary.simpleMessage("Try again"),
    "try_different_login": MessageLookupByLibrary.simpleMessage(
      "Having trouble signing in?",
    ),
    "uc_info": MessageLookupByLibrary.simpleMessage("Open UC page"),
    "ucs": MessageLookupByLibrary.simpleMessage("UCS"),
    "unavailable": MessageLookupByLibrary.simpleMessage("Unavailable"),
    "until": MessageLookupByLibrary.simpleMessage("Until"),
    "valid_email": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "view_course_details": MessageLookupByLibrary.simpleMessage(
      "View course details",
    ),
    "widget_prompt": MessageLookupByLibrary.simpleMessage(
      "Choose a widget to add to your personal area:",
    ),
    "wrong_credentials_exception": MessageLookupByLibrary.simpleMessage(
      "Invalid credentials",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
  };
}
