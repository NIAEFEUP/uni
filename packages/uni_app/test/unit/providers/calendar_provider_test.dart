import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';

class FakeCalendarFetcher extends CalendarFetcherJson{
  Map<String, List<CalendarEvent>> mockGroups = {
    'pt': [],
    'en': [],
  };

  @override
  Future<List<CalendarEvent>> getCalendar(String locale) async {
    return mockGroups[locale] ?? [];
  }
}

void main(){
  late ProviderContainer container;
  late FakeCalendarFetcher fakeFetcher;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PreferencesController.prefs = await SharedPreferences.getInstance();

    fakeFetcher = FakeCalendarFetcher();

    container = ProviderContainer(
      overrides: [
        calendarProvider.overrideWith(
          () => CalendarNotifier(fetcher: fakeFetcher),
        ),
      ],
    );
    addTearDown(() => container.dispose());
  });

  test('Must load correct english JSON successfully', () async {
    const fakeJSON = '''
    [
      {
        "name": "Start of classes, others",
        "start_date": "2025-09-15",
        "end_date": "2025-09-15"
      }
    ]
  ''';
  
    final dataList = json.decode(fakeJSON) as List<dynamic>;

    final eventMap = dataList.first as Map<String, dynamic>;
    final event = CalendarEvent.fromJson(eventMap);

    fakeFetcher.mockGroups['en'] = [event];

    final data = await container.read(calendarProvider.future);

    expect(data?.getEvents(AppLocale.en).length, 1);
    expect(data?.getEvents(AppLocale.pt), isEmpty);
    expect(data?.getEvents(AppLocale.en).first.name, 'Start of classes, others');
  });

}



