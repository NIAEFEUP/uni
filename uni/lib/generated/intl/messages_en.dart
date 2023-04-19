// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(time) => "last refresh at ${time}";

  static String m1(time) =>
      "${Intl.plural(time, one: 'Refreshed ${time} minute ago', other: 'Refreshed ${time} minutes ago')}";

  static String m2(title) => "${Intl.select(title, {
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
          })}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account_card_title":
            MessageLookupByLibrary.simpleMessage("Checking account"),
        "add_widget": MessageLookupByLibrary.simpleMessage("Add widget"),
        "all_widgets_added": MessageLookupByLibrary.simpleMessage(
            "All available widgets have already been added to your personal area!"),
        "balance": MessageLookupByLibrary.simpleMessage("Balance:"),
        "bus_card_title": MessageLookupByLibrary.simpleMessage("Buses"),
        "bus_error":
            MessageLookupByLibrary.simpleMessage("Unable to get information"),
        "buses_personalize":
            MessageLookupByLibrary.simpleMessage("Personalize your buses here"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "edit_off": MessageLookupByLibrary.simpleMessage("Edit"),
        "edit_on": MessageLookupByLibrary.simpleMessage("Finish editing"),
        "exam_card_title": MessageLookupByLibrary.simpleMessage("Exams"),
        "fee_date":
            MessageLookupByLibrary.simpleMessage("Deadline for next fee:"),
        "fee_notification":
            MessageLookupByLibrary.simpleMessage("Notify next deadline:"),
        "last_refresh_time": m0,
        "last_timestamp": m1,
        "logout": MessageLookupByLibrary.simpleMessage("Log out"),
        "nav_title": m2,
        "no_data": MessageLookupByLibrary.simpleMessage(
            "There is no data to show at this time"),
        "no_exams": MessageLookupByLibrary.simpleMessage(
            "You have no exams scheduled\n"),
        "no_selected_exams": MessageLookupByLibrary.simpleMessage(
            "There are no exams to present"),
        "restaurant_card_title":
            MessageLookupByLibrary.simpleMessage("Restaurants"),
        "schedule_card_title": MessageLookupByLibrary.simpleMessage("Schedule"),
        "stcp_stops":
            MessageLookupByLibrary.simpleMessage("STCP - Upcoming Trips"),
        "widget_prompt": MessageLookupByLibrary.simpleMessage(
            "Choose a widget to add to your personal area:")
      };
}
