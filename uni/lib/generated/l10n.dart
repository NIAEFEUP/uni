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

  /// `All available widgets have already been added to your personal area!`
  String get all_widgets_added {
    return Intl.message(
      'All available widgets have already been added to your personal area!',
      name: 'all_widgets_added',
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

  /// `Exam Filter Settings`
  String get exams_filter {
    return Intl.message(
      'Exam Filter Settings',
      name: 'exams_filter',
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

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
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

  /// `Semester`
  String get semester {
    return Intl.message(
      'Semester',
      name: 'semester',
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
