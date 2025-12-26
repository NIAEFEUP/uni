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
  bool shouldThrowError = false;

  Map<String, List<CalendarEvent>> mockGroups = {
    'pt': [],
    'en': [],
  };

  @override
  Future<List<CalendarEvent>> getCalendar(String locale) async {
    if(shouldThrowError){
      throw Exception('Error loading calendar');
    }
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

  group('CalendarNotifier Tests', () {

  test('Must load English event successfully', () async {
    final event = CalendarEvent(
      name: 'Start of classes, others',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    );

    fakeFetcher.mockGroups['en'] = [event];

    final data = await container.read(calendarProvider.future);
    expect(data?.getEvents(AppLocale.en).first.name, equals('Start of classes, others'));
    expect(data?.getEvents(AppLocale.pt), isEmpty);
  });

  test('Must load Portuguese event successfully', () async {
    final event = CalendarEvent(
      name: 'Início de aulas, outros',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    );

    fakeFetcher.mockGroups['pt'] = [event];

    final data = await container.read(calendarProvider.future);
    expect(data?.getEvents(AppLocale.pt).first.name, equals('Início de aulas, outros'));
    expect(data?.getEvents(AppLocale.en), isEmpty);
  });
});

  test('Must return empty lists when no events are provided', () async {
  fakeFetcher.mockGroups['en'] = [];
  fakeFetcher.mockGroups['pt'] = [];

  final data = await container.read(calendarProvider.future);

  expect(data?.getEvents(AppLocale.en), isEmpty);
  expect(data?.getEvents(AppLocale.pt), isEmpty);
  expect(data?.getEvents(AppLocale.en).length, 0);
  expect(data?.getEvents(AppLocale.pt).length, 0);

});
  test('Must handle fetcher error gracefully', () {
    fakeFetcher.shouldThrowError = true; 

    expect(
      container.read(calendarProvider.future), 
      throwsA(isA<Exception>())
    );  
   
});  
}




