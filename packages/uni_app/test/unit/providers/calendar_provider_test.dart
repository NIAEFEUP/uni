import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';

class FakeCalendarFetcher extends CalendarFetcherJson{
  bool throwError = false;

  Map<String, List<CalendarEvent>> mockGroups = {
    'pt': [],
    'en': [],
  };

  @override
  Future<List<CalendarEvent>> getCalendar(String locale) async {
    if(throwError){
      throw Exception('Fetcher failed');
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
  test('Must handle fetcher error gracefully', () async {
    fakeFetcher.throwError = true; 

    await container.read(calendarProvider.future).catchError((_) => null);

    final state = container.read(calendarProvider);

    expect(state.hasError, isTrue);
    expect(state.error.toString(), contains('Fetcher failed'));
});  

  test('Must reload from remote if cache is expired', () async {
    final oldDate = DateTime.now().subtract(const Duration(days: 31));
    await PreferencesController.setLastDataClassUpdateTime('CalendarNotifier', oldDate,);

    fakeFetcher.mockGroups['en'] = [CalendarEvent(
      name: 'Início de aulas, outros',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    )];

    final data = await container.read(calendarProvider.future);

    await Future<void>.delayed(Duration.zero);

    final dataPostLoading = PreferencesController.getLastDataClassUpdateTime('CalendarNotifier');
  
    expect(dataPostLoading!.isAfter(oldDate), isTrue);
    expect(data?.getEvents(AppLocale.en).first.name, equals('Início de aulas, outros'));
  });

  test('Data must update when the language changes', () async {
    final eventPT = CalendarEvent(
      name: 'Início de aulas, outros',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    );

    final eventEN = CalendarEvent(
      name: 'Start of classes, others',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    );

    fakeFetcher.mockGroups['pt'] = [eventPT];
    fakeFetcher.mockGroups['en'] = [eventEN];

    final dataPt = await container.read(calendarProvider.future);

    expect(dataPt?.getEvents(AppLocale.pt).first.name, equals('Início de aulas, outros'));
    
    container.invalidate(calendarProvider);

    final dataEn = await container.read(calendarProvider.future);

    expect(dataEn?.getEvents(AppLocale.en).first.name, equals('Start of classes, others'));

  });

  test('Should not update timestamp when reading the same value on valid cache', () async {
    final now = DateTime.now();

    await PreferencesController.setLastDataClassUpdateTime('CalendarNotifier', now);

    final eventPT = CalendarEvent(
      name: 'Início de aulas, outros',
      startDate: DateTime.parse('2025-09-15'),
      endDate: DateTime.parse('2025-09-15'),
    );

    fakeFetcher.mockGroups['pt'] = [eventPT];

    await container.read(calendarProvider.future);

    final time1 = PreferencesController.getLastDataClassUpdateTime('CalendarNotifier');

    await Future<void>.delayed(Duration.zero);

    await container.read(calendarProvider.future);
    final time2 = PreferencesController.getLastDataClassUpdateTime('CalendarNotifier');

    await Future<void>.delayed(Duration.zero);
    
    expect(time1, equals(time2));
  });
}
