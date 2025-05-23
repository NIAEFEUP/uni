// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Do you really want to exit?`
  String get exit_confirm {
    return Intl.message(
      'Do you really want to exit?',
      name: 'exit_confirm',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `About us`
  String get about {
    return Intl.message(
      'About us',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Academic services`
  String get academic_services {
    return Intl.message(
      'Academic services',
      name: 'academic_services',
      desc: '',
      args: [],
    );
  }

  /// `Checking account`
  String get account_card_title {
    return Intl.message(
      'Checking account',
      name: 'account_card_title',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add quota`
  String get add_quota {
    return Intl.message(
      'Add quota',
      name: 'add_quota',
      desc: '',
      args: [],
    );
  }

  /// `Add widget`
  String get add_widget {
    return Intl.message(
      'Add widget',
      name: 'add_widget',
      desc: '',
      args: [],
    );
  }

  /// `Add restaurants`
  String get add_restaurants {
    return Intl.message(
      'Add restaurants',
      name: 'add_restaurants',
      desc: '',
      args: [],
    );
  }

  /// `By entering you agree with these`
  String get agree_terms {
    return Intl.message(
      'By entering you agree with these',
      name: 'agree_terms',
      desc: '',
      args: [],
    );
  }

  /// `All available widgets have already been added to your personal area!`
  String get all_widgets_added {
    return Intl.message(
      'All available widgets have already been added to your personal area!',
      name: 'all_widgets_added',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one college`
  String get at_least_one_college {
    return Intl.message(
      'Select at least one college',
      name: 'at_least_one_college',
      desc: '',
      args: [],
    );
  }

  /// `Available amount`
  String get available_amount {
    return Intl.message(
      'Available amount',
      name: 'available_amount',
      desc: '',
      args: [],
    );
  }

  /// `Average`
  String get average {
    return Intl.message(
      'Average',
      name: 'average',
      desc: '',
      args: [],
    );
  }

  /// `We collect anonymous usage data to help improve your experience. You can opt out anytime in the settings.`
  String get banner_info {
    return Intl.message(
      'We collect anonymous usage data to help improve your experience. You can opt out anytime in the settings.',
      name: 'banner_info',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Bibliography`
  String get bibliography {
    return Intl.message(
      'Bibliography',
      name: 'bibliography',
      desc: '',
      args: [],
    );
  }

  /// `Breakfast`
  String get breakfast {
    return Intl.message(
      'Breakfast',
      name: 'breakfast',
      desc: '',
      args: [],
    );
  }

  /// `Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!`
  String get bs_description {
    return Intl.message(
      'Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!',
      name: 'bs_description',
      desc: '',
      args: [],
    );
  }

  /// `Bug found, how to reproduce it, etc.`
  String get bug_description {
    return Intl.message(
      'Bug found, how to reproduce it, etc.',
      name: 'bug_description',
      desc: '',
      args: [],
    );
  }

  /// `Unable to get information`
  String get bus_error {
    return Intl.message(
      'Unable to get information',
      name: 'bus_error',
      desc: '',
      args: [],
    );
  }

  /// `Personalize your buses here`
  String get buses_personalize {
    return Intl.message(
      'Personalize your buses here',
      name: 'buses_personalize',
      desc: '',
      args: [],
    );
  }

  /// `Favorite buses will be displayed in the favorites 'Bus' widget. The remaining ones will only be displayed on the page.`
  String get buses_text {
    return Intl.message(
      'Favorite buses will be displayed in the favorites \'Bus\' widget. The remaining ones will only be displayed on the page.',
      name: 'buses_text',
      desc: '',
      args: [],
    );
  }

  /// `Select the buses you want information about:`
  String get bus_information {
    return Intl.message(
      'Select the buses you want information about:',
      name: 'bus_information',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to change the password?`
  String get change_prompt {
    return Intl.message(
      'Do you want to change the password?',
      name: 'change_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get check_internet {
    return Intl.message(
      'Check your internet connection',
      name: 'check_internet',
      desc: '',
      args: [],
    );
  }

  /// `Classes`
  String get course_class {
    return Intl.message(
      'Classes',
      name: 'course_class',
      desc: '',
      args: [],
    );
  }

  /// `Class Registration`
  String get class_registration {
    return Intl.message(
      'Class Registration',
      name: 'class_registration',
      desc: '',
      args: [],
    );
  }

  /// `College: `
  String get college {
    return Intl.message(
      'College: ',
      name: 'college',
      desc: '',
      args: [],
    );
  }

  /// `select your college(s)`
  String get college_select {
    return Intl.message(
      'select your college(s)',
      name: 'college_select',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get conclude {
    return Intl.message(
      'Done',
      name: 'conclude',
      desc: '',
      args: [],
    );
  }

  /// `Configured Buses`
  String get configured_buses {
    return Intl.message(
      'Configured Buses',
      name: 'configured_buses',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `I consent to this information being reviewed by NIAEFEUP and may be deleted at my request.`
  String get consent {
    return Intl.message(
      'I consent to this information being reviewed by NIAEFEUP and may be deleted at my request.',
      name: 'consent',
      desc: '',
      args: [],
    );
  }

  /// `Contact (optional)`
  String get contact {
    return Intl.message(
      'Contact (optional)',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Copy center`
  String get copy_center {
    return Intl.message(
      'Copy center',
      name: 'copy_center',
      desc: '',
      args: [],
    );
  }

  /// `Floor -1 of building B | AEFEUP building`
  String get copy_center_building {
    return Intl.message(
      'Floor -1 of building B | AEFEUP building',
      name: 'copy_center_building',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get course_info {
    return Intl.message(
      'Info',
      name: 'course_info',
      desc: '',
      args: [],
    );
  }

  /// `Current state: `
  String get current_state {
    return Intl.message(
      'Current state: ',
      name: 'current_state',
      desc: '',
      args: [],
    );
  }

  /// `Current academic year: `
  String get current_year {
    return Intl.message(
      'Current academic year: ',
      name: 'current_year',
      desc: '',
      args: [],
    );
  }

  /// `Decrement 1,00€`
  String get decrement {
    return Intl.message(
      'Decrement 1,00€',
      name: 'decrement',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Email where you want to be contacted`
  String get desired_email {
    return Intl.message(
      'Email where you want to be contacted',
      name: 'desired_email',
      desc: '',
      args: [],
    );
  }

  /// `Dinner`
  String get dinner {
    return Intl.message(
      'Dinner',
      name: 'dinner',
      desc: '',
      args: [],
    );
  }

  /// `D. Beatriz's stationery store`
  String get dona_bia {
    return Intl.message(
      'D. Beatriz\'s stationery store',
      name: 'dona_bia',
      desc: '',
      args: [],
    );
  }

  /// `Floor -1 of building B (B-142)`
  String get dona_bia_building {
    return Intl.message(
      'Floor -1 of building B (B-142)',
      name: 'dona_bia_building',
      desc: '',
      args: [],
    );
  }

  /// `ECTS performed: `
  String get ects {
    return Intl.message(
      'ECTS performed: ',
      name: 'ects',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit_off {
    return Intl.message(
      'Edit',
      name: 'edit_off',
      desc: '',
      args: [],
    );
  }

  /// `Finish editing`
  String get edit_on {
    return Intl.message(
      'Finish editing',
      name: 'edit_on',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in this field`
  String get empty_text {
    return Intl.message(
      'Please fill in this field',
      name: 'empty_text',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get evaluation {
    return Intl.message(
      'Evaluation',
      name: 'evaluation',
      desc: '',
      args: [],
    );
  }

  /// `Eligibility for exams`
  String get frequency {
    return Intl.message(
      'Eligibility for exams',
      name: 'frequency',
      desc: '',
      args: [],
    );
  }

  /// `Exams Filter Settings`
  String get exams_filter {
    return Intl.message(
      'Exams Filter Settings',
      name: 'exams_filter',
      desc: '',
      args: [],
    );
  }

  /// `Your password has expired`
  String get expired_password {
    return Intl.message(
      'Your password has expired',
      name: 'expired_password',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get failed_login {
    return Intl.message(
      'Login failed',
      name: 'failed_login',
      desc: '',
      args: [],
    );
  }

  /// `Deadline`
  String get fee_date {
    return Intl.message(
      'Deadline',
      name: 'fee_date',
      desc: '',
      args: [],
    );
  }

  /// `Fee deadline`
  String get fee_notification {
    return Intl.message(
      'Fee deadline',
      name: 'fee_notification',
      desc: '',
      args: [],
    );
  }

  /// `Report an issue or suggest an improvement`
  String get feedback_description {
    return Intl.message(
      'Report an issue or suggest an improvement',
      name: 'feedback_description',
      desc: '',
      args: [],
    );
  }

  /// `Year of first registration: `
  String get first_year_registration {
    return Intl.message(
      'Year of first registration: ',
      name: 'first_year_registration',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Floors`
  String get floors {
    return Intl.message(
      'Floors',
      name: 'floors',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Generate reference`
  String get generate_reference {
    return Intl.message(
      'Generate reference',
      name: 'generate_reference',
      desc: '',
      args: [],
    );
  }

  /// `General Registration`
  String get geral_registration {
    return Intl.message(
      'General Registration',
      name: 'geral_registration',
      desc: '',
      args: [],
    );
  }

  /// `Enrollment for Improvement`
  String get improvement_registration {
    return Intl.message(
      'Enrollment for Improvement',
      name: 'improvement_registration',
      desc: '',
      args: [],
    );
  }

  /// `Increment 1,00€`
  String get increment {
    return Intl.message(
      'Increment 1,00€',
      name: 'increment',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credentials`
  String get invalid_credentials {
    return Intl.message(
      'Invalid credentials',
      name: 'invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get keep_login {
    return Intl.message(
      'Remember me',
      name: 'keep_login',
      desc: '',
      args: [],
    );
  }

  /// `last refresh at {time}`
  String last_refresh_time(Object time) {
    return Intl.message(
      'last refresh at $time',
      name: 'last_refresh_time',
      desc: '',
      args: [time],
    );
  }

  /// `{time, plural, zero{Refreshed {time} minutes ago} one{Refreshed {time} minute ago} other{Refreshed {time} minutes ago}}`
  String last_timestamp(num time) {
    return Intl.plural(
      time,
      zero: 'Refreshed $time minutes ago',
      one: 'Refreshed $time minute ago',
      other: 'Refreshed $time minutes ago',
      name: 'last_timestamp',
      desc: '',
      args: [time],
    );
  }

  /// `Leave feedback`
  String get leave_feedback {
    return Intl.message(
      'Leave feedback',
      name: 'leave_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Library Occupation`
  String get library_occupation {
    return Intl.message(
      'Library Occupation',
      name: 'library_occupation',
      desc: '',
      args: [],
    );
  }

  /// `Lunch`
  String get lunch {
    return Intl.message(
      'Lunch',
      name: 'lunch',
      desc: '',
      args: [],
    );
  }

  /// `Error downloading the file`
  String get download_error {
    return Intl.message(
      'Error downloading the file',
      name: 'download_error',
      desc: '',
      args: [],
    );
  }

  /// `Loading Terms and Conditions...`
  String get loading_terms {
    return Intl.message(
      'Loading Terms and Conditions...',
      name: 'loading_terms',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Snackbar`
  String get snackbar {
    return Intl.message(
      'Snackbar',
      name: 'snackbar',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Menus`
  String get menus {
    return Intl.message(
      'Menus',
      name: 'menus',
      desc: '',
      args: [],
    );
  }

  /// `Minimum value: 1,00 €`
  String get min_value_reference {
    return Intl.message(
      'Minimum value: 1,00 €',
      name: 'min_value_reference',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia center`
  String get multimedia_center {
    return Intl.message(
      'Multimedia center',
      name: 'multimedia_center',
      desc: '',
      args: [],
    );
  }

  /// `{title, select, horario{Schedule} exames{Exams} area{Personal Area} cadeiras{Course Units} autocarros{Buses} locais{Places} restaurantes{Restaurants} calendario{Calendar} biblioteca{Library} percurso_academico{Academic Path} mapa{Map} faculdade{Faculty} other{Other}}`
  String nav_title(Object title) {
    return Intl.select(
      title,
      {
        'horario': 'Schedule',
        'exames': 'Exams',
        'area': 'Personal Area',
        'cadeiras': 'Course Units',
        'autocarros': 'Buses',
        'locais': 'Places',
        'restaurantes': 'Restaurants',
        'calendario': 'Calendar',
        'biblioteca': 'Library',
        'percurso_academico': 'Academic Path',
        'mapa': 'Map',
        'faculdade': 'Faculty',
        'other': 'Other',
      },
      name: 'nav_title',
      desc: '',
      args: [title],
    );
  }

  /// `News`
  String get news {
    return Intl.message(
      'News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Don't miss any bus!`
  String get no_bus {
    return Intl.message(
      'Don\'t miss any bus!',
      name: 'no_bus',
      desc: '',
      args: [],
    );
  }

  /// `No configured stops`
  String get no_bus_stops {
    return Intl.message(
      'No configured stops',
      name: 'no_bus_stops',
      desc: '',
      args: [],
    );
  }

  /// `There are no classes to display`
  String get no_class {
    return Intl.message(
      'There are no classes to display',
      name: 'no_class',
      desc: '',
      args: [],
    );
  }

  /// `You have no classes this week`
  String get no_classes_this_week {
    return Intl.message(
      'You have no classes this week',
      name: 'no_classes_this_week',
      desc: '',
      args: [],
    );
  }

  /// `No classes to present`
  String get no_classes {
    return Intl.message(
      'No classes to present',
      name: 'no_classes',
      desc: '',
      args: [],
    );
  }

  /// `You don't have classes on`
  String get no_classes_on {
    return Intl.message(
      'You don\'t have classes on',
      name: 'no_classes_on',
      desc: '',
      args: [],
    );
  }

  /// `You don't have classes on`
  String get no_classes_on_weekend {
    return Intl.message(
      'You don\'t have classes on',
      name: 'no_classes_on_weekend',
      desc: '',
      args: [],
    );
  }

  /// `no college`
  String get no_college {
    return Intl.message(
      'no college',
      name: 'no_college',
      desc: '',
      args: [],
    );
  }

  /// `No course units in the selected period`
  String get no_course_units {
    return Intl.message(
      'No course units in the selected period',
      name: 'no_course_units',
      desc: '',
      args: [],
    );
  }

  /// `There is no data to show at this time`
  String get no_data {
    return Intl.message(
      'There is no data to show at this time',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `No date`
  String get no_date {
    return Intl.message(
      'No date',
      name: 'no_date',
      desc: '',
      args: [],
    );
  }

  /// `No events found`
  String get no_events {
    return Intl.message(
      'No events found',
      name: 'no_events',
      desc: '',
      args: [],
    );
  }

  /// `You have no exams scheduled\n`
  String get no_exams {
    return Intl.message(
      'You have no exams scheduled\n',
      name: 'no_exams',
      desc: '',
      args: [],
    );
  }

  /// `Looks like you are on vacation!`
  String get no_exams_label {
    return Intl.message(
      'Looks like you are on vacation!',
      name: 'no_exams_label',
      desc: '',
      args: [],
    );
  }

  /// `There's no files attached`
  String get no_files {
    return Intl.message(
      'There\'s no files attached',
      name: 'no_files',
      desc: '',
      args: [],
    );
  }

  /// `You have nothing to see!`
  String get no_files_label {
    return Intl.message(
      'You have nothing to see!',
      name: 'no_files_label',
      desc: '',
      args: [],
    );
  }

  /// `No favorite restaurants open`
  String get no_favorite_restaurants {
    return Intl.message(
      'No favorite restaurants open',
      name: 'no_favorite_restaurants',
      desc: '',
      args: [],
    );
  }

  /// `There is no information to display`
  String get no_info {
    return Intl.message(
      'There is no information to display',
      name: 'no_info',
      desc: '',
      args: [],
    );
  }

  /// `There is no information available about meals`
  String get no_menu_info {
    return Intl.message(
      'There is no information available about meals',
      name: 'no_menu_info',
      desc: '',
      args: [],
    );
  }

  /// `There is no information available about places`
  String get no_places_info {
    return Intl.message(
      'There is no information available about places',
      name: 'no_places_info',
      desc: '',
      args: [],
    );
  }

  /// `There are no meals available`
  String get no_menus {
    return Intl.message(
      'There are no meals available',
      name: 'no_menus',
      desc: '',
      args: [],
    );
  }

  /// `Unnamed course`
  String get no_name_course {
    return Intl.message(
      'Unnamed course',
      name: 'no_name_course',
      desc: '',
      args: [],
    );
  }

  /// `There are no references to pay`
  String get no_references {
    return Intl.message(
      'There are no references to pay',
      name: 'no_references',
      desc: '',
      args: [],
    );
  }

  /// `No match`
  String get no_results {
    return Intl.message(
      'No match',
      name: 'no_results',
      desc: '',
      args: [],
    );
  }

  /// `There are no course units to display`
  String get no_selected_courses {
    return Intl.message(
      'There are no course units to display',
      name: 'no_selected_courses',
      desc: '',
      args: [],
    );
  }

  /// `There are no exams to present`
  String get no_selected_exams {
    return Intl.message(
      'There are no exams to present',
      name: 'no_selected_exams',
      desc: '',
      args: [],
    );
  }

  /// `No print balance information`
  String get no_print_info {
    return Intl.message(
      'No print balance information',
      name: 'no_print_info',
      desc: '',
      args: [],
    );
  }

  /// `No library occupation information available`
  String get no_library_info {
    return Intl.message(
      'No library occupation information available',
      name: 'no_library_info',
      desc: '',
      args: [],
    );
  }

  /// `Type of occurrence`
  String get occurrence_type {
    return Intl.message(
      'Type of occurrence',
      name: 'occurrence_type',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get of_month {
    return Intl.message(
      'of',
      name: 'of_month',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't open the link`
  String get no_link {
    return Intl.message(
      'We couldn\'t open the link',
      name: 'no_link',
      desc: '',
      args: [],
    );
  }

  /// `It looks like you're offline`
  String get no_internet {
    return Intl.message(
      'It looks like you\'re offline',
      name: 'no_internet',
      desc: '',
      args: [],
    );
  }

  /// `No files found`
  String get no_files_found {
    return Intl.message(
      'No files found',
      name: 'no_files_found',
      desc: '',
      args: [],
    );
  }

  /// `No trips found at the moment`
  String get no_trips {
    return Intl.message(
      'No trips found at the moment',
      name: 'no_trips',
      desc: '',
      args: [],
    );
  }

  /// `Other links`
  String get other_links {
    return Intl.message(
      'Other links',
      name: 'other_links',
      desc: '',
      args: [],
    );
  }

  /// `For security reasons, passwords must be changed periodically.`
  String get pass_change_request {
    return Intl.message(
      'For security reasons, passwords must be changed periodically.',
      name: 'pass_change_request',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Pending references`
  String get pendent_references {
    return Intl.message(
      'Pending references',
      name: 'pendent_references',
      desc: '',
      args: [],
    );
  }

  /// `Face-to-face assistance`
  String get personal_assistance {
    return Intl.message(
      'Face-to-face assistance',
      name: 'personal_assistance',
      desc: '',
      args: [],
    );
  }

  /// `Press again to exit`
  String get press_again {
    return Intl.message(
      'Press again to exit',
      name: 'press_again',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Print balance`
  String get print_balance {
    return Intl.message(
      'Print balance',
      name: 'print_balance',
      desc: '',
      args: [],
    );
  }

  /// `File opened successfully`
  String get successful_open {
    return Intl.message(
      'File opened successfully',
      name: 'successful_open',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permission_denied {
    return Intl.message(
      'Permission denied',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Program`
  String get program {
    return Intl.message(
      'Program',
      name: 'program',
      desc: '',
      args: [],
    );
  }

  /// `Error opening the file`
  String get open_error {
    return Intl.message(
      'Error opening the file',
      name: 'open_error',
      desc: '',
      args: [],
    );
  }

  /// `No app found to open the file`
  String get no_app {
    return Intl.message(
      'No app found to open the file',
      name: 'no_app',
      desc: '',
      args: [],
    );
  }

  /// `Error loading the information`
  String get load_error {
    return Intl.message(
      'Error loading the information',
      name: 'load_error',
      desc: '',
      args: [],
    );
  }

  /// `Prints`
  String get prints {
    return Intl.message(
      'Prints',
      name: 'prints',
      desc: '',
      args: [],
    );
  }

  /// `Brief identification of the problem`
  String get problem_id {
    return Intl.message(
      'Brief identification of the problem',
      name: 'problem_id',
      desc: '',
      args: [],
    );
  }

  /// `The generated reference data will appear in Sigarra, checking account.\nProfile > Checking Account`
  String get reference_sigarra_help {
    return Intl.message(
      'The generated reference data will appear in Sigarra, checking account.\nProfile > Checking Account',
      name: 'reference_sigarra_help',
      desc: '',
      args: [],
    );
  }

  /// `Reference created successfully!`
  String get reference_success {
    return Intl.message(
      'Reference created successfully!',
      name: 'reference_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get remove {
    return Intl.message(
      'Delete',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Report error`
  String get report_error {
    return Intl.message(
      'Report error',
      name: 'report_error',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to see your favorite restaurants in the main page?`
  String get restaurant_main_page {
    return Intl.message(
      'Do you want to see your favorite restaurants in the main page?',
      name: 'restaurant_main_page',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get room {
    return Intl.message(
      'Room',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `School Calendar`
  String get school_calendar {
    return Intl.message(
      'School Calendar',
      name: 'school_calendar',
      desc: '',
      args: [],
    );
  }

  /// `Semester`
  String get semester {
    return Intl.message(
      'Semester',
      name: 'semester',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred in sending`
  String get sent_error {
    return Intl.message(
      'An error occurred in sending',
      name: 'sent_error',
      desc: '',
      args: [],
    );
  }

  /// `Some error!`
  String get some_error {
    return Intl.message(
      'Some error!',
      name: 'some_error',
      desc: '',
      args: [],
    );
  }

  /// `STCP - Upcoming Trips`
  String get stcp_stops {
    return Intl.message(
      'STCP - Upcoming Trips',
      name: 'stcp_stops',
      desc: '',
      args: [],
    );
  }

  /// `Student Number`
  String get student_number {
    return Intl.message(
      'Student Number',
      name: 'student_number',
      desc: '',
      args: [],
    );
  }

  /// `Sent with success`
  String get success {
    return Intl.message(
      'Sent with success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Telephone assistance`
  String get tele_assistance {
    return Intl.message(
      'Telephone assistance',
      name: 'tele_assistance',
      desc: '',
      args: [],
    );
  }

  /// `Face-to-face and telephone assistance`
  String get tele_personal_assistance {
    return Intl.message(
      'Face-to-face and telephone assistance',
      name: 'tele_personal_assistance',
      desc: '',
      args: [],
    );
  }

  /// `Telephone`
  String get telephone {
    return Intl.message(
      'Telephone',
      name: 'telephone',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Open UC page`
  String get uc_info {
    return Intl.message(
      'Open UC page',
      name: 'uc_info',
      desc: '',
      args: [],
    );
  }

  /// `Unavailable`
  String get unavailable {
    return Intl.message(
      'Unavailable',
      name: 'unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get valid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Choose a widget to add to your personal area:`
  String get widget_prompt {
    return Intl.message(
      'Choose a widget to add to your personal area:',
      name: 'widget_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get see_more {
    return Intl.message(
      'See more',
      name: 'see_more',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to log out? Your local data will be deleted and you will have to log in again.`
  String get confirm_logout {
    return Intl.message(
      'Do you really want to log out? Your local data will be deleted and you will have to log in again.',
      name: 'confirm_logout',
      desc: '',
      args: [],
    );
  }

  /// `Collect usage statistics`
  String get collect_usage_stats {
    return Intl.message(
      'Collect usage statistics',
      name: 'collect_usage_stats',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get try_again {
    return Intl.message(
      'Try again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Having trouble signing in?`
  String get try_different_login {
    return Intl.message(
      'Having trouble signing in?',
      name: 'try_different_login',
      desc: '',
      args: [],
    );
  }

  /// `Login with credentials`
  String get login_with_credentials {
    return Intl.message(
      'Login with credentials',
      name: 'login_with_credentials',
      desc: '',
      args: [],
    );
  }

  /// `Failed to authenticate`
  String get fail_to_authenticate {
    return Intl.message(
      'Failed to authenticate',
      name: 'fail_to_authenticate',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credentials`
  String get wrong_credentials_exception {
    return Intl.message(
      'Invalid credentials',
      name: 'wrong_credentials_exception',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get internet_status_exception {
    return Intl.message(
      'Check your internet connection',
      name: 'internet_status_exception',
      desc: '',
      args: [],
    );
  }

  /// `Visual Detail`
  String get bug_description_visual_detail {
    return Intl.message(
      'Visual Detail',
      name: 'bug_description_visual_detail',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get bug_description_error {
    return Intl.message(
      'Error',
      name: 'bug_description_error',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion`
  String get bug_description_Suggestion {
    return Intl.message(
      'Suggestion',
      name: 'bug_description_Suggestion',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected Behaviour`
  String get bug_description_unexpected_behaviour {
    return Intl.message(
      'Unexpected Behaviour',
      name: 'bug_description_unexpected_behaviour',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get bug_description_other {
    return Intl.message(
      'Other',
      name: 'bug_description_other',
      desc: '',
      args: [],
    );
  }

  /// `Add photo`
  String get add_photo {
    return Intl.message(
      'Add photo',
      name: 'add_photo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload`
  String get failed_upload {
    return Intl.message(
      'Failed to upload',
      name: 'failed_upload',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get schedule {
    return Intl.message(
      'Schedule',
      name: 'schedule',
      desc: '',
      args: [],
    );
  }

  /// `Instructors`
  String get instructors {
    return Intl.message(
      'Instructors',
      name: 'instructors',
      desc: '',
      args: [],
    );
  }

  /// `Remaining Instructors`
  String get remaining_instructors {
    return Intl.message(
      'Remaining Instructors',
      name: 'remaining_instructors',
      desc: '',
      args: [],
    );
  }

  /// `Assessments`
  String get assessments {
    return Intl.message(
      'Assessments',
      name: 'assessments',
      desc: '',
      args: [],
    );
  }

  /// `No exams scheduled`
  String get noExamsScheduled {
    return Intl.message(
      'No exams scheduled',
      name: 'noExamsScheduled',
      desc: '',
      args: [],
    );
  }

  /// `No instructors assigned`
  String get noInstructors {
    return Intl.message(
      'No instructors assigned',
      name: 'noInstructors',
      desc: '',
      args: [],
    );
  }

  /// `Course Regent`
  String get courseRegent {
    return Intl.message(
      'Course Regent',
      name: 'courseRegent',
      desc: '',
      args: [],
    );
  }

  /// `Instructor`
  String get instructor {
    return Intl.message(
      'Instructor',
      name: 'instructor',
      desc: '',
      args: [],
    );
  }

  /// `Lectures`
  String get lectures {
    return Intl.message(
      'Lectures',
      name: 'lectures',
      desc: '',
      args: [],
    );
  }

  /// `Exams`
  String get exams {
    return Intl.message(
      'Exams',
      name: 'exams',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all_feminine {
    return Intl.message(
      'All',
      name: 'all_feminine',
      desc: '',
      args: [],
    );
  }

  /// `{type, select, all_dishes{All dishes} meat_dishes{Meat dishes} fish_dishes{Fish dishes} vegetarian_dishes{Vegetarian dishes} soups{Soups} salads{Salads} diet_dishes{Diet dishes} dishes_of_the_day{Dishes of the Day} other{Other}}`
  String dish_type(Object type) {
    return Intl.select(
      type,
      {
        'all_dishes': 'All dishes',
        'meat_dishes': 'Meat dishes',
        'fish_dishes': 'Fish dishes',
        'vegetarian_dishes': 'Vegetarian dishes',
        'soups': 'Soups',
        'salads': 'Salads',
        'diet_dishes': 'Diet dishes',
        'dishes_of_the_day': 'Dishes of the Day',
        'other': 'Other',
      },
      name: 'dish_type',
      desc: '',
      args: [type],
    );
  }

  /// `Dish Types`
  String get dish_types {
    return Intl.message(
      'Dish Types',
      name: 'dish_types',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get select_all {
    return Intl.message(
      'Select All',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorite_filter {
    return Intl.message(
      'Favorites',
      name: 'favorite_filter',
      desc: '',
      args: [],
    );
  }

  /// `{period, select, lunch{Lunch} dinner{Dinner} other{Other}}`
  String restaurant_period(Object period) {
    return Intl.select(
      period,
      {
        'lunch': 'Lunch',
        'dinner': 'Dinner',
        'other': 'Other',
      },
      name: 'restaurant_period',
      desc: '',
      args: [period],
    );
  }

  /// `No courses we're found`
  String get no_courses {
    return Intl.message(
      'No courses we\'re found',
      name: 'no_courses',
      desc: '',
      args: [],
    );
  }

  /// `Try to refresh the page`
  String get no_courses_description {
    return Intl.message(
      'Try to refresh the page',
      name: 'no_courses_description',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Drag and drop elements`
  String get drag_and_drop {
    return Intl.message(
      'Drag and drop elements',
      name: 'drag_and_drop',
      desc: '',
      args: [],
    );
  }

  /// `Available elements`
  String get available_elements {
    return Intl.message(
      'Available elements',
      name: 'available_elements',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Restaurants`
  String get restaurants {
    return Intl.message(
      'Restaurants',
      name: 'restaurants',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `UCS`
  String get ucs {
    return Intl.message(
      'UCS',
      name: 'ucs',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Add to calendar`
  String get add_to_calendar {
    return Intl.message(
      'Add to calendar',
      name: 'add_to_calendar',
      desc: '',
      args: [],
    );
  }

  /// `View course details`
  String get view_course_details {
    return Intl.message(
      'View course details',
      name: 'view_course_details',
      desc: '',
      args: [],
    );
  }

  /// `Until`
  String get until {
    return Intl.message(
      'Until',
      name: 'until',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get services {
    return Intl.message(
      'Services',
      name: 'services',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'PT'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
