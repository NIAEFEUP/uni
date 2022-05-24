import 'package:uni/model/class_registration_model.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:uni/model/entities/schedule_preference_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SchedulePreferenceList', () {
    test('Reorder one option to a lower priority', () {
      final ScheduleOption option1 = ScheduleOption(name: 'A');
      final ScheduleOption option2 = ScheduleOption(name: 'B');
      final ScheduleOption option3 = ScheduleOption(name: 'C');
      final ScheduleOption option4 = ScheduleOption(name: 'D');
      final ScheduleOption option5 = ScheduleOption(name: 'E');
      final SchedulePreferenceList preferences = SchedulePreferenceList(
        Semester.second, [
          option1,
          option2,
          option3,
          option4,
          option5,
        ],
      );

      preferences.reorder(0, 4);
      final expectedPreferences = [
        option2,
        option3,
        option4,
        option1,
        option5,
      ];
      expect(preferences.length, expectedPreferences.length);
      for (int i = 0; i < expectedPreferences.length; i++) {
        expect(preferences[i].name, expectedPreferences[i].name);
      }
    });

    test('Reorder one option to a higher priority', () {
      final ScheduleOption option1 = ScheduleOption(name: 'A');
      final ScheduleOption option2 = ScheduleOption(name: 'B');
      final ScheduleOption option3 = ScheduleOption(name: 'C');
      final ScheduleOption option4 = ScheduleOption(name: 'D');
      final ScheduleOption option5 = ScheduleOption(name: 'E');
      final SchedulePreferenceList preferences = SchedulePreferenceList(
        Semester.second, [
          option1,
          option2,
          option3,
          option4,
          option5,
        ],
      );

      preferences.reorder(4, 0);
      final expectedPreferences = [option5, option1, option2, option3, option4];
      expect(preferences.length, expectedPreferences.length);
      for (int i = 0; i < expectedPreferences.length; i++) {
        expect(preferences[i].name, expectedPreferences[i].name);
      }
    });

    test('Reorder multiple options', () {
      final ScheduleOption option1 = ScheduleOption(name: 'A');
      final ScheduleOption option2 = ScheduleOption(name: 'B');
      final ScheduleOption option3 = ScheduleOption(name: 'C');
      final ScheduleOption option4 = ScheduleOption(name: 'D');
      final ScheduleOption option5 = ScheduleOption(name: 'E');
      final SchedulePreferenceList preferences = SchedulePreferenceList(
        Semester.second, [
          option1,
          option2,
          option3,
          option4,
          option5,
        ],
      );

      preferences.reorder(2, 3);
      preferences.reorder(2, 4);
      preferences.reorder(4, 1);
      final expectedPreferences = [option1, option5, option2, option4, option3];
      expect(preferences.length, expectedPreferences.length);
      for (int i = 0; i < expectedPreferences.length; i++) {
        expect(preferences[i].name, expectedPreferences[i].name);
      }
    });

    test('Add preferences', () {
      final ScheduleOption option1 = ScheduleOption(name: 'A');
      final ScheduleOption option2 = ScheduleOption(name: 'B');
      final ScheduleOption option3 = ScheduleOption(name: 'C');
      final ScheduleOption option4 = ScheduleOption(name: 'D');
      final ScheduleOption option5 = ScheduleOption(name: 'E');
      final SchedulePreferenceList preferences = SchedulePreferenceList(
        Semester.second, [],
      );

      preferences.add(option1);
      preferences.add(option2);
      preferences.add(option3);
      preferences.add(option4);
      preferences.add(option5);

      final expectedPreferences = [option1, option2, option3, option4, option5];
      expect(preferences.length, expectedPreferences.length);
      for (int i = 0; i < expectedPreferences.length; i++) {
        expect(preferences[i].name, expectedPreferences[i].name);
      }
    });

    test('Remove preferences', () {
      final ScheduleOption option1 = ScheduleOption(name: 'A');
      final ScheduleOption option2 = ScheduleOption(name: 'B');
      final ScheduleOption option3 = ScheduleOption(name: 'C');
      final ScheduleOption option4 = ScheduleOption(name: 'D');
      final ScheduleOption option5 = ScheduleOption(name: 'E');
      final SchedulePreferenceList preferences = SchedulePreferenceList(
        Semester.second, [
        option1,
        option2,
        option3,
        option4,
        option5,
      ],
      );

      preferences.remove(0);
      preferences.remove(3);

      final expectedPreferences = [option2, option3, option4];
      expect(preferences.length, expectedPreferences.length);
      for (int i = 0; i < expectedPreferences.length; i++) {
        expect(preferences[i].name, expectedPreferences[i].name);
      }
    });
  });
}
