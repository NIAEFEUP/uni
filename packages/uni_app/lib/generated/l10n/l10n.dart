import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @exit_confirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to exit?'**
  String get exit_confirm;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get about;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @academic_services.
  ///
  /// In en, this message translates to:
  /// **'Academic services'**
  String get academic_services;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @account_card_title.
  ///
  /// In en, this message translates to:
  /// **'Checking account'**
  String get account_card_title;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_quota.
  ///
  /// In en, this message translates to:
  /// **'Add quota'**
  String get add_quota;

  /// No description provided for @add_widget.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get add_widget;

  /// No description provided for @add_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Add restaurants'**
  String get add_restaurants;

  /// No description provided for @agree_terms.
  ///
  /// In en, this message translates to:
  /// **'By entering you agree with these'**
  String get agree_terms;

  /// No description provided for @all_widgets_added.
  ///
  /// In en, this message translates to:
  /// **'All available widgets have already been added to your personal area!'**
  String get all_widgets_added;

  /// No description provided for @at_least_one_college.
  ///
  /// In en, this message translates to:
  /// **'Select at least one college'**
  String get at_least_one_college;

  /// No description provided for @available_amount.
  ///
  /// In en, this message translates to:
  /// **'Available amount'**
  String get available_amount;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @banner_info.
  ///
  /// In en, this message translates to:
  /// **'We collect anonymous usage data to help improve your experience. You can opt out anytime in the settings.'**
  String get banner_info;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @bibliography.
  ///
  /// In en, this message translates to:
  /// **'Bibliography'**
  String get bibliography;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @bs_description.
  ///
  /// In en, this message translates to:
  /// **'Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!'**
  String get bs_description;

  /// No description provided for @bug_description.
  ///
  /// In en, this message translates to:
  /// **'Bug found, how to reproduce it, etc.'**
  String get bug_description;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @change_prompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the password?'**
  String get change_prompt;

  /// No description provided for @check_internet.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get check_internet;

  /// No description provided for @course_class.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get course_class;

  /// No description provided for @class_registration.
  ///
  /// In en, this message translates to:
  /// **'Class Registration'**
  String get class_registration;

  /// No description provided for @college.
  ///
  /// In en, this message translates to:
  /// **'College: '**
  String get college;

  /// No description provided for @college_select.
  ///
  /// In en, this message translates to:
  /// **'select your college(s)'**
  String get college_select;

  /// No description provided for @conclude.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get conclude;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @consent.
  ///
  /// In en, this message translates to:
  /// **'I consent to this information being reviewed by NIAEFEUP and may be deleted at my request.'**
  String get consent;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact (optional)'**
  String get contact;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @copy_center.
  ///
  /// In en, this message translates to:
  /// **'Copy center'**
  String get copy_center;

  /// No description provided for @copy_center_building.
  ///
  /// In en, this message translates to:
  /// **'Floor -1 of building B | AEFEUP building'**
  String get copy_center_building;

  /// No description provided for @course_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get course_info;

  /// No description provided for @current_state.
  ///
  /// In en, this message translates to:
  /// **'Current state: '**
  String get current_state;

  /// No description provided for @current_year.
  ///
  /// In en, this message translates to:
  /// **'Current academic year: '**
  String get current_year;

  /// No description provided for @decrement.
  ///
  /// In en, this message translates to:
  /// **'Decrement 1,00€'**
  String get decrement;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @desired_email.
  ///
  /// In en, this message translates to:
  /// **'Email where you want to be contacted'**
  String get desired_email;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @dona_bia.
  ///
  /// In en, this message translates to:
  /// **'D. Beatriz\'s stationery store'**
  String get dona_bia;

  /// No description provided for @dona_bia_building.
  ///
  /// In en, this message translates to:
  /// **'Floor -1 of building B (B-142)'**
  String get dona_bia_building;

  /// No description provided for @dont_show_again.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dont_show_again;

  /// No description provided for @ects.
  ///
  /// In en, this message translates to:
  /// **'ECTS performed: '**
  String get ects;

  /// No description provided for @edit_off.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_off;

  /// No description provided for @edit_on.
  ///
  /// In en, this message translates to:
  /// **'Finish editing'**
  String get edit_on;

  /// No description provided for @empty_text.
  ///
  /// In en, this message translates to:
  /// **'Please fill in this field'**
  String get empty_text;

  /// No description provided for @evaluation.
  ///
  /// In en, this message translates to:
  /// **'Evaluation'**
  String get evaluation;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Eligibility for exams'**
  String get frequency;

  /// No description provided for @exams_filter.
  ///
  /// In en, this message translates to:
  /// **'Exams Filter Settings'**
  String get exams_filter;

  /// No description provided for @expired_password.
  ///
  /// In en, this message translates to:
  /// **'Your password has expired'**
  String get expired_password;

  /// No description provided for @failed_login.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get failed_login;

  /// No description provided for @fee_date.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get fee_date;

  /// No description provided for @fee_notification.
  ///
  /// In en, this message translates to:
  /// **'Fee deadline'**
  String get fee_notification;

  /// No description provided for @feedback_description.
  ///
  /// In en, this message translates to:
  /// **'Report an issue or suggest an improvement'**
  String get feedback_description;

  /// No description provided for @first_year_registration.
  ///
  /// In en, this message translates to:
  /// **'Year of first registration: '**
  String get first_year_registration;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @floors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get floors;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @generate_reference.
  ///
  /// In en, this message translates to:
  /// **'Generate reference'**
  String get generate_reference;

  /// No description provided for @geral_registration.
  ///
  /// In en, this message translates to:
  /// **'General Registration'**
  String get geral_registration;

  /// No description provided for @improvement_registration.
  ///
  /// In en, this message translates to:
  /// **'Enrollment for Improvement'**
  String get improvement_registration;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment 1,00€'**
  String get increment;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalid_credentials;

  /// No description provided for @keep_login.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get keep_login;

  /// No description provided for @last_refresh_time.
  ///
  /// In en, this message translates to:
  /// **'last refresh at {time}'**
  String last_refresh_time(Object time);

  /// No description provided for @last_timestamp.
  ///
  /// In en, this message translates to:
  /// **'{time, plural, zero{Refreshed {time} minutes ago} one{Refreshed {time} minute ago} other{Refreshed {time} minutes ago}}'**
  String last_timestamp(num time);

  /// No description provided for @leave_feedback.
  ///
  /// In en, this message translates to:
  /// **'Leave feedback'**
  String get leave_feedback;

  /// No description provided for @library_occupation.
  ///
  /// In en, this message translates to:
  /// **'Library Occupation'**
  String get library_occupation;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @download_error.
  ///
  /// In en, this message translates to:
  /// **'Error downloading the file'**
  String get download_error;

  /// No description provided for @loading_terms.
  ///
  /// In en, this message translates to:
  /// **'Loading Terms and Conditions...'**
  String get loading_terms;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @snackbar.
  ///
  /// In en, this message translates to:
  /// **'Snackbar'**
  String get snackbar;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @menus.
  ///
  /// In en, this message translates to:
  /// **'Menus'**
  String get menus;

  /// No description provided for @min_value_reference.
  ///
  /// In en, this message translates to:
  /// **'Minimum value: 1,00 €'**
  String get min_value_reference;

  /// No description provided for @multimedia_center.
  ///
  /// In en, this message translates to:
  /// **'Multimedia center'**
  String get multimedia_center;

  /// No description provided for @nav_title.
  ///
  /// In en, this message translates to:
  /// **'{title, select, horario{Schedule} exames{Exams} area{Personal Area} cadeiras{Course Units} locais{Places} restaurantes{Restaurants} calendario{Calendar} biblioteca{Library} percurso_academico{Academic Path} mapa{Map} faculdade{Faculty} bug_report{Leave Feedback} conta_corrente{Current Account} other{Other}}'**
  String nav_title(String title);

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @no_class.
  ///
  /// In en, this message translates to:
  /// **'There are no classes to display'**
  String get no_class;

  /// No description provided for @no_classes_this_week.
  ///
  /// In en, this message translates to:
  /// **'You have no classes this week'**
  String get no_classes_this_week;

  /// No description provided for @no_classes.
  ///
  /// In en, this message translates to:
  /// **'No classes to present'**
  String get no_classes;

  /// No description provided for @no_news.
  ///
  /// In en, this message translates to:
  /// **'No news to display'**
  String get no_news;

  /// No description provided for @no_classes_on.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have classes on'**
  String get no_classes_on;

  /// No description provided for @no_classes_on_weekend.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have classes on'**
  String get no_classes_on_weekend;

  /// No description provided for @no_classes_today.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any more classes today.'**
  String get no_classes_today;

  /// No description provided for @no_college.
  ///
  /// In en, this message translates to:
  /// **'no college'**
  String get no_college;

  /// No description provided for @no_course_units.
  ///
  /// In en, this message translates to:
  /// **'No course units in the selected period'**
  String get no_course_units;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'There is no data to show at this time'**
  String get no_data;

  /// No description provided for @no_date.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get no_date;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @no_events.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get no_events;

  /// No description provided for @no_exams.
  ///
  /// In en, this message translates to:
  /// **'You have no exams scheduled\n'**
  String get no_exams;

  /// No description provided for @no_exams_label.
  ///
  /// In en, this message translates to:
  /// **'Looks like you are on vacation!'**
  String get no_exams_label;

  /// No description provided for @no_files.
  ///
  /// In en, this message translates to:
  /// **'There are no files attached'**
  String get no_files;

  /// No description provided for @no_files_label.
  ///
  /// In en, this message translates to:
  /// **'You have nothing to see!'**
  String get no_files_label;

  /// No description provided for @no_favorite_restaurants.
  ///
  /// In en, this message translates to:
  /// **'No favorite restaurants open'**
  String get no_favorite_restaurants;

  /// No description provided for @no_info.
  ///
  /// In en, this message translates to:
  /// **'There is no information to display'**
  String get no_info;

  /// No description provided for @no_menu_info.
  ///
  /// In en, this message translates to:
  /// **'There is no information available about meals'**
  String get no_menu_info;

  /// No description provided for @no_places_info.
  ///
  /// In en, this message translates to:
  /// **'There is no information available about places'**
  String get no_places_info;

  /// No description provided for @no_menus.
  ///
  /// In en, this message translates to:
  /// **'There are no meals available'**
  String get no_menus;

  /// No description provided for @no_name_course.
  ///
  /// In en, this message translates to:
  /// **'Unnamed course'**
  String get no_name_course;

  /// No description provided for @no_references.
  ///
  /// In en, this message translates to:
  /// **'There are no references to pay'**
  String get no_references;

  /// No description provided for @no_results.
  ///
  /// In en, this message translates to:
  /// **'No match'**
  String get no_results;

  /// No description provided for @no_selected_courses.
  ///
  /// In en, this message translates to:
  /// **'There are no course units to display'**
  String get no_selected_courses;

  /// No description provided for @no_selected_exams.
  ///
  /// In en, this message translates to:
  /// **'There are no exams to present'**
  String get no_selected_exams;

  /// No description provided for @no_print_info.
  ///
  /// In en, this message translates to:
  /// **'No print balance information'**
  String get no_print_info;

  /// No description provided for @no_library_info.
  ///
  /// In en, this message translates to:
  /// **'No library occupation information available'**
  String get no_library_info;

  /// No description provided for @occurrence_type.
  ///
  /// In en, this message translates to:
  /// **'Type of occurrence'**
  String get occurrence_type;

  /// No description provided for @of_month.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get of_month;

  /// No description provided for @no_link.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t open the link'**
  String get no_link;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'re offline'**
  String get no_internet;

  /// No description provided for @no_files_found.
  ///
  /// In en, this message translates to:
  /// **'No files found'**
  String get no_files_found;

  /// No description provided for @no_trips.
  ///
  /// In en, this message translates to:
  /// **'No trips found at the moment'**
  String get no_trips;

  /// No description provided for @other_links.
  ///
  /// In en, this message translates to:
  /// **'Other links'**
  String get other_links;

  /// No description provided for @pass_change_request.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, passwords must be changed periodically.'**
  String get pass_change_request;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pendent_references.
  ///
  /// In en, this message translates to:
  /// **'Pending references'**
  String get pendent_references;

  /// No description provided for @personal_assistance.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face assistance'**
  String get personal_assistance;

  /// No description provided for @press_again.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit'**
  String get press_again;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @print_balance.
  ///
  /// In en, this message translates to:
  /// **'Print balance'**
  String get print_balance;

  /// No description provided for @successful_open.
  ///
  /// In en, this message translates to:
  /// **'File opened successfully'**
  String get successful_open;

  /// No description provided for @permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permission_denied;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @open_error.
  ///
  /// In en, this message translates to:
  /// **'Error opening the file'**
  String get open_error;

  /// No description provided for @no_app.
  ///
  /// In en, this message translates to:
  /// **'No app found to open the file'**
  String get no_app;

  /// No description provided for @load_error.
  ///
  /// In en, this message translates to:
  /// **'Error loading the information'**
  String get load_error;

  /// No description provided for @prints.
  ///
  /// In en, this message translates to:
  /// **'Prints'**
  String get prints;

  /// No description provided for @problem_id.
  ///
  /// In en, this message translates to:
  /// **'Brief identification of the problem'**
  String get problem_id;

  /// No description provided for @reference_sigarra_help.
  ///
  /// In en, this message translates to:
  /// **'The generated reference data will appear in Sigarra, checking account.\nProfile > Checking Account'**
  String get reference_sigarra_help;

  /// No description provided for @reference_success.
  ///
  /// In en, this message translates to:
  /// **'Reference created successfully!'**
  String get reference_success;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get remove;

  /// No description provided for @report_error.
  ///
  /// In en, this message translates to:
  /// **'Report error'**
  String get report_error;

  /// No description provided for @restaurant_main_page.
  ///
  /// In en, this message translates to:
  /// **'Do you want to see your favorite restaurants in the main page?'**
  String get restaurant_main_page;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @school_calendar.
  ///
  /// In en, this message translates to:
  /// **'School Calendar'**
  String get school_calendar;

  /// No description provided for @semester.
  ///
  /// In en, this message translates to:
  /// **'Semester'**
  String get semester;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sent_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred in sending'**
  String get sent_error;

  /// No description provided for @some_error.
  ///
  /// In en, this message translates to:
  /// **'Some error!'**
  String get some_error;

  /// No description provided for @student_number.
  ///
  /// In en, this message translates to:
  /// **'Student Number'**
  String get student_number;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Sent with success'**
  String get success;

  /// No description provided for @tele_assistance.
  ///
  /// In en, this message translates to:
  /// **'Telephone assistance'**
  String get tele_assistance;

  /// No description provided for @tele_personal_assistance.
  ///
  /// In en, this message translates to:
  /// **'Face-to-face and telephone assistance'**
  String get tele_personal_assistance;

  /// No description provided for @telephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get telephone;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms;

  /// No description provided for @terms_change.
  ///
  /// In en, this message translates to:
  /// **'Changes on uni\'s Terms and Conditions'**
  String get terms_change;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @uc_info.
  ///
  /// In en, this message translates to:
  /// **'Open UC page'**
  String get uc_info;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @user_informations.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get user_informations;

  /// No description provided for @valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get valid_email;

  /// No description provided for @widget_prompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a widget to add to your personal area:'**
  String get widget_prompt;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @see_more.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get see_more;

  /// No description provided for @search_here.
  ///
  /// In en, this message translates to:
  /// **'Search here'**
  String get search_here;

  /// No description provided for @confirm_logout.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out? Your local data will be deleted and you will have to log in again.'**
  String get confirm_logout;

  /// No description provided for @collect_usage_stats.
  ///
  /// In en, this message translates to:
  /// **'Collect usage statistics'**
  String get collect_usage_stats;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @try_different_login.
  ///
  /// In en, this message translates to:
  /// **'Having trouble signing in?'**
  String get try_different_login;

  /// No description provided for @login_with_credentials.
  ///
  /// In en, this message translates to:
  /// **'Login with credentials'**
  String get login_with_credentials;

  /// No description provided for @spotted_an_error.
  ///
  /// In en, this message translates to:
  /// **'Something not right?'**
  String get spotted_an_error;

  /// No description provided for @report_bug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get report_bug;

  /// No description provided for @fail_to_authenticate.
  ///
  /// In en, this message translates to:
  /// **'Failed to authenticate'**
  String get fail_to_authenticate;

  /// No description provided for @wrong_credentials_exception.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get wrong_credentials_exception;

  /// No description provided for @internet_status_exception.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get internet_status_exception;

  /// No description provided for @bug_description_visual_detail.
  ///
  /// In en, this message translates to:
  /// **'Visual Detail'**
  String get bug_description_visual_detail;

  /// No description provided for @bug_description_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get bug_description_error;

  /// No description provided for @bug_description_Suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get bug_description_Suggestion;

  /// No description provided for @bug_description_unexpected_behaviour.
  ///
  /// In en, this message translates to:
  /// **'Unexpected Behaviour'**
  String get bug_description_unexpected_behaviour;

  /// No description provided for @bug_description_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get bug_description_other;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get add_photo;

  /// No description provided for @failed_upload.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload'**
  String get failed_upload;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @instructors.
  ///
  /// In en, this message translates to:
  /// **'Instructors'**
  String get instructors;

  /// No description provided for @remaining_instructors.
  ///
  /// In en, this message translates to:
  /// **'Remaining Instructors'**
  String get remaining_instructors;

  /// No description provided for @assessments.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get assessments;

  /// No description provided for @noExamsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No exams scheduled'**
  String get noExamsScheduled;

  /// No description provided for @noInstructors.
  ///
  /// In en, this message translates to:
  /// **'No instructors assigned'**
  String get noInstructors;

  /// No description provided for @courseRegent.
  ///
  /// In en, this message translates to:
  /// **'Course Regent'**
  String get courseRegent;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @classProfessor.
  ///
  /// In en, this message translates to:
  /// **'Class Professor'**
  String get classProfessor;

  /// No description provided for @lectures.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get lectures;

  /// No description provided for @exams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get exams;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @all_feminine.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all_feminine;

  /// No description provided for @dish_type.
  ///
  /// In en, this message translates to:
  /// **'{type, select, all_dishes{All dishes} meat_dishes{Meat dishes} fish_dishes{Fish dishes} vegetarian_dishes{Vegetarian dishes} soups{Soups} salads{Salads} diet_dishes{Diet dishes} dishes_of_the_day{Dishes of the Day} closed{Closed} other{Other}}'**
  String dish_type(String type);

  /// No description provided for @dish_types.
  ///
  /// In en, this message translates to:
  /// **'Dish Types'**
  String get dish_types;

  /// No description provided for @select_all.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get select_all;

  /// No description provided for @favorite_filter.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorite_filter;

  /// No description provided for @restaurant_period.
  ///
  /// In en, this message translates to:
  /// **'{period, select, lunch{Lunch} dinner{Dinner} other{Other}}'**
  String restaurant_period(String period);

  /// No description provided for @no_courses.
  ///
  /// In en, this message translates to:
  /// **'No courses we\'re found'**
  String get no_courses;

  /// No description provided for @no_courses_description.
  ///
  /// In en, this message translates to:
  /// **'Try to refresh the page'**
  String get no_courses_description;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @drag_and_drop.
  ///
  /// In en, this message translates to:
  /// **'Drag and drop elements'**
  String get drag_and_drop;

  /// No description provided for @available_elements.
  ///
  /// In en, this message translates to:
  /// **'Available elements'**
  String get available_elements;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @library_building.
  ///
  /// In en, this message translates to:
  /// **'Building C (Library)'**
  String get library_building;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @tomorrows_meals.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Menu'**
  String get tomorrows_meals;

  /// No description provided for @no_menu_tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow\'s Menu Unavailable'**
  String get no_menu_tomorrow;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @ucs.
  ///
  /// In en, this message translates to:
  /// **'UCS'**
  String get ucs;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @add_to_calendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get add_to_calendar;

  /// No description provided for @view_course_details.
  ///
  /// In en, this message translates to:
  /// **'View course details'**
  String get view_course_details;

  /// No description provided for @until.
  ///
  /// In en, this message translates to:
  /// **'Until'**
  String get until;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @goi.
  ///
  /// In en, this message translates to:
  /// **'Psychology and Guidance Service'**
  String get goi;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @exams_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Stay always updated with your exams'**
  String get exams_intro_message;

  /// No description provided for @schedule_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Keep track of your daily classes and activities'**
  String get schedule_intro_message;

  /// No description provided for @restaurants_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Discover campus dining options and menus'**
  String get restaurants_intro_message;

  /// No description provided for @services_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Access various campus services at your fingertips'**
  String get services_intro_message;

  /// No description provided for @map_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Explore the campus with our interactive map'**
  String get map_intro_message;

  /// No description provided for @notifications_intro_message.
  ///
  /// In en, this message translates to:
  /// **'Would you like to receive notifications regarding important updates and alerts, including fee deadlines?'**
  String get notifications_intro_message;

  /// No description provided for @nationalities.
  ///
  /// In en, this message translates to:
  /// **'Nationalities'**
  String get nationalities;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @identification_documents.
  ///
  /// In en, this message translates to:
  /// **'Identification Documents'**
  String get identification_documents;

  /// No description provided for @addresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get addresses;

  /// No description provided for @no_info_description.
  ///
  /// In en, this message translates to:
  /// **'Try to refresh the page'**
  String get no_info_description;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow:'**
  String get tomorrow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today:'**
  String get today;

  /// No description provided for @nextclasses.
  ///
  /// In en, this message translates to:
  /// **'Here are your classes for '**
  String get nextclasses;

  /// No description provided for @no_course_unit_classes.
  ///
  /// In en, this message translates to:
  /// **'No classes have been assigned to this course unit yet'**
  String get no_course_unit_classes;

  /// No description provided for @no_course_unit_info.
  ///
  /// In en, this message translates to:
  /// **'This course unit has no information available yet'**
  String get no_course_unit_info;

  /// No description provided for @unable_to_load_data.
  ///
  /// In en, this message translates to:
  /// **'Unable to load data'**
  String get unable_to_load_data;

  /// No description provided for @pedagogical_surveys.
  ///
  /// In en, this message translates to:
  /// **'Pedagogical Surveys'**
  String get pedagogical_surveys;

  /// No description provided for @pedagogical_surveys_description.
  ///
  /// In en, this message translates to:
  /// **'Have you already filled out the pedagogical surveys? If not, please take a moment to fill them out. Your feedback is valuable and helps us improve the quality of education at your course.'**
  String get pedagogical_surveys_description;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @no_restaurants_available.
  ///
  /// In en, this message translates to:
  /// **'There are no restaurants to display'**
  String get no_restaurants_available;

  /// No description provided for @no_restaurants_available_sublabel.
  ///
  /// In en, this message translates to:
  /// **'Bring your lunchbox from home.'**
  String get no_restaurants_available_sublabel;

  /// No description provided for @vending_machine.
  ///
  /// In en, this message translates to:
  /// **'Vending Machine'**
  String get vending_machine;

  /// No description provided for @coffee_machine.
  ///
  /// In en, this message translates to:
  /// **'Coffee Machine'**
  String get coffee_machine;

  /// No description provided for @atm.
  ///
  /// In en, this message translates to:
  /// **'ATM'**
  String get atm;

  /// No description provided for @printer.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get printer;

  /// No description provided for @wc.
  ///
  /// In en, this message translates to:
  /// **'WC'**
  String get wc;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @current_account.
  ///
  /// In en, this message translates to:
  /// **'Current Account'**
  String get current_account;

  /// No description provided for @current_account_description.
  ///
  /// In en, this message translates to:
  /// **'Track your fees, due dates and payment history.'**
  String get current_account_description;

  /// No description provided for @account_faculty.
  ///
  /// In en, this message translates to:
  /// **'Faculty'**
  String get account_faculty;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @upcoming_due.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Due'**
  String get upcoming_due;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @tuition_fees.
  ///
  /// In en, this message translates to:
  /// **'Tuition Fees'**
  String get tuition_fees;

  /// No description provided for @general_history.
  ///
  /// In en, this message translates to:
  /// **'General History'**
  String get general_history;

  /// No description provided for @balance_description.
  ///
  /// In en, this message translates to:
  /// **'Your total outstanding balance'**
  String get balance_description;

  /// No description provided for @fee_date_description.
  ///
  /// In en, this message translates to:
  /// **'Due date for your next payment'**
  String get fee_date_description;

  /// No description provided for @print_balance_description.
  ///
  /// In en, this message translates to:
  /// **'Funds for university printing services'**
  String get print_balance_description;

  /// No description provided for @interest_on_late_payments.
  ///
  /// In en, this message translates to:
  /// **'Interest on late payments'**
  String get interest_on_late_payments;

  /// No description provided for @due_in.
  ///
  /// In en, this message translates to:
  /// **'Due in'**
  String get due_in;

  /// No description provided for @no_records.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get no_records;

  /// No description provided for @no_current_account_info.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing the page or check back later.'**
  String get no_current_account_info;

  /// No description provided for @no_pending_label.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get no_pending_label;

  /// No description provided for @no_pending_sublabel.
  ///
  /// In en, this message translates to:
  /// **'You have no pending payments.'**
  String get no_pending_sublabel;

  /// No description provided for @no_history_label.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get no_history_label;

  /// No description provided for @no_history_sublabel.
  ///
  /// In en, this message translates to:
  /// **'Your payment history will appear here.'**
  String get no_history_sublabel;

  /// No description provided for @no_tuition_fees_label.
  ///
  /// In en, this message translates to:
  /// **'No tuition fees found'**
  String get no_tuition_fees_label;

  /// No description provided for @no_tuition_fees_sublabel.
  ///
  /// In en, this message translates to:
  /// **'Your tuition fee records will appear here.'**
  String get no_tuition_fees_sublabel;

  /// No description provided for @feedback_type_title_section.
  ///
  /// In en, this message translates to:
  /// **'Select the type of feedback'**
  String get feedback_type_title_section;

  /// No description provided for @feedback_type_description_section.
  ///
  /// In en, this message translates to:
  /// **'Please choose the category that best describes your feedback to help us address it effectively.'**
  String get feedback_type_description_section;

  /// No description provided for @feedback_description_section.
  ///
  /// In en, this message translates to:
  /// **'Provide a clear and concise title along with a detailed description of the issue or suggestion. The more information you provide, the better we can understand and address your feedback.'**
  String get feedback_description_section;

  /// No description provided for @feedback_privacy_section.
  ///
  /// In en, this message translates to:
  /// **'Privacy and Consent'**
  String get feedback_privacy_section;

  /// No description provided for @feedback_privacy_description_section.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. You consent to the collection and use of your feedback and any attached images for the purpose of improving our app. You can choose to provide your email for follow-up, but it is not required.'**
  String get feedback_privacy_description_section;

  /// No description provided for @feedback_images_title_section.
  ///
  /// In en, this message translates to:
  /// **'Attach images'**
  String get feedback_images_title_section;

  /// No description provided for @feedback_images_empty_section.
  ///
  /// In en, this message translates to:
  /// **'Attached images will appear here.'**
  String get feedback_images_empty_section;

  /// No description provided for @feedback_consent_title.
  ///
  /// In en, this message translates to:
  /// **'Consent to data collection'**
  String get feedback_consent_title;

  /// No description provided for @edit_homepage.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit_homepage;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @no_records_for_filter.
  ///
  /// In en, this message translates to:
  /// **'No records for this filter.'**
  String get no_records_for_filter;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get session_expired;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statistics_year.
  ///
  /// In en, this message translates to:
  /// **'Statistics {year}'**
  String statistics_year(Object year);

  /// No description provided for @statistics_distribution_description.
  ///
  /// In en, this message translates to:
  /// **'Distribution of passed, failed, and not evaluated students'**
  String get statistics_distribution_description;

  /// No description provided for @statistics_not_found.
  ///
  /// In en, this message translates to:
  /// **'No statistics were found for this year or the previous year.'**
  String get statistics_not_found;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @not_evaluated.
  ///
  /// In en, this message translates to:
  /// **'Not evaluated'**
  String get not_evaluated;

  /// No description provided for @enrolled.
  ///
  /// In en, this message translates to:
  /// **'Total Enrolled'**
  String get enrolled;

  /// No description provided for @feedback_github_title_section.
  ///
  /// In en, this message translates to:
  /// **'Want to see how the app is built? Check out our GitHub'**
  String get feedback_github_title_section;

  /// No description provided for @welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to university!'**
  String get welcome_title;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'The UNI team welcomes you and wishes you the best of luck on your course!'**
  String get welcome_message;

  /// No description provided for @settings_app_version.
  ///
  /// In en, this message translates to:
  /// **'You are using uni {version}'**
  String settings_app_version(String version);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'pt':
      return SPt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
