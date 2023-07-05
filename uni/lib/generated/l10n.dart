// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

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

  /// `Add widget`
  String get add_widget {
    return Intl.message(
      'Add widget',
      name: 'add_widget',
      desc: '',
      args: [],
    );
  }

  /// `By entering you confirm that you agree with these Terms and Conditions`
  String get agree_terms {
    return Intl.message(
      'By entering you confirm that you agree with these Terms and Conditions',
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

  /// `Average: `
  String get average {
    return Intl.message(
      'Average: ',
      name: 'average',
      desc: '',
      args: [],
    );
  }

  /// `Balance:`
  String get balance {
    return Intl.message(
      'Balance:',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `Did you find any bugs in the application?\nDo you have any suggestions for the app?\nTell us so we can improve!`
  String get bs_description {
    return Intl.message(
      'Did you find any bugs in the application?\\nDo you have any suggestions for the app?\\nTell us so we can improve!',
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

  /// `ECTs performed: `
  String get ects {
    return Intl.message(
      'ECTs performed: ',
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

  /// `Exam Filter Settings`
  String get exams_filter {
    return Intl.message(
      'Exam Filter Settings',
      name: 'exams_filter',
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

  /// `Deadline for next fee:`
  String get fee_date {
    return Intl.message(
      'Deadline for next fee:',
      name: 'fee_date',
      desc: '',
      args: [],
    );
  }

  /// `Notify next deadline:`
  String get fee_notification {
    return Intl.message(
      'Notify next deadline:',
      name: 'fee_notification',
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

  /// `Stay signed in`
  String get keep_login {
    return Intl.message(
      'Stay signed in',
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

  /// `Library Occupation`
  String get library_occupation {
    return Intl.message(
      'Library Occupation',
      name: 'library_occupation',
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

  /// `Multimedia center`
  String get multimedia_center {
    return Intl.message(
      'Multimedia center',
      name: 'multimedia_center',
      desc: '',
      args: [],
    );
  }

  /// `{title, select, horario{Schedule} exames{Exams} area{Personal Area} cadeiras{Course Units} autocarros{Buses} locais{Places} restaurantes{Restaurants} calendario{Calendar} biblioteca{Library} uteis{Utils} sobre{About} bugs{Bugs and Suggestions} other{Other}}`
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
        'uteis': 'Utils',
        'sobre': 'About',
        'bugs': 'Bugs and Suggestions',
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

  /// `No configured stops`
  String get no_bus_stops {
    return Intl.message(
      'No configured stops',
      name: 'no_bus_stops',
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

  /// `You have no exams scheduled\n`
  String get no_exams {
    return Intl.message(
      'You have no exams scheduled\n',
      name: 'no_exams',
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

  /// `Type of occurrence`
  String get occurrence_type {
    return Intl.message(
      'Type of occurrence',
      name: 'occurrence_type',
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

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
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

  /// `Brief identification of the problem`
  String get problem_id {
    return Intl.message(
      'Brief identification of the problem',
      name: 'problem_id',
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

  /// `STCP - Upcoming Trips`
  String get stcp_stops {
    return Intl.message(
      'STCP - Upcoming Trips',
      name: 'stcp_stops',
      desc: '',
      args: [],
    );
  }

  /// `student number`
  String get student_number {
    return Intl.message(
      'student number',
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
