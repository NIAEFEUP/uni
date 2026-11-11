import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/providers/riverpod/hide_sensitive_data_provider.dart';
import 'package:uni/view/profile/widgets/hide_sensitive_data_switch.dart';
import 'package:uni_ui/cards/course_grade_card.dart';
import 'package:uni_ui/cards/generic_card.dart';
import 'package:uni_ui/common_widgets/fade_in.dart';
import 'package:uni_ui/courses/average_bar.dart';
import 'package:uni_ui/icons.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({'hide_sensitive_data': true});
    PreferencesController.prefs = await SharedPreferences.getInstance();
  });

  testWidgets('eye and settings share visibility and persist both changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, child) {
                final hidden = ref.watch(hideSensitiveDataProvider);
                return Column(
                  children: [
                    AverageBar(
                      key: const ValueKey('course'),
                      average: 15.5,
                      completedCredits: 60,
                      totalCredits: 180,
                      statusText: 'Attending',
                      averageText: 'Average',
                      hiddenValueText: 'Hidden',
                      showValueHint: 'Show academic information',
                      hideValueHint: 'Hide academic information',
                      hideSensitiveData: hidden,
                      onToggleVisibility: () => ref
                          .read(hideSensitiveDataProvider.notifier)
                          .setHidden(!hidden),
                    ),
                    CourseGradeCard(
                      courseName: 'Algorithms',
                      ects: 6,
                      grade: '9',
                      tooltip: 'Algorithms',
                      hideGrade: hidden,
                      onTap: () {},
                    ),
                    const HideSensitiveDataSwitch(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    void expectHidden(bool hidden) {
      expect(find.text('15.5'), hidden ? findsNothing : findsOneWidget);
      expect(find.text('60/180'), hidden ? findsNothing : findsOneWidget);
      expect(find.text('9'), hidden ? findsNothing : findsOneWidget);
      expect(find.text('6 ECTS'), findsOneWidget);
      expect(find.byType(UniIcon), hidden ? findsOneWidget : findsNothing);
      expect(tester.widget<Switch>(find.byType(Switch)).value, hidden);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        hidden ? 0 : closeTo(1 / 3, 0.001),
      );
      final cardContext = tester.element(find.byType(CourseGradeCard));
      expect(
        tester
            .widget<GenericCard>(
              find.descendant(
                of: find.byType(CourseGradeCard),
                matching: find.byType(GenericCard),
              ),
            )
            .color,
        hidden
            ? null
            : Theme.of(cardContext).colorScheme.secondary.withAlpha(120),
      );
    }

    expectHidden(true);
    await tester.tap(find.text('Average'));
    await tester.pump();
    double progress() => tester
        .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
        .value!;
    void expectNumberOpacity(Matcher opacity) {
      for (final value in ['15.5', '60/180', '9']) {
        final fade = find.ancestor(
          of: find.text(value),
          matching: find.byType(Opacity),
        );
        expect(tester.widget<Opacity>(fade).opacity, opacity);
      }
    }

    expect(progress(), 0);
    expectNumberOpacity(equals(0));
    await tester.pump(const Duration(milliseconds: 90));
    expectNumberOpacity(allOf(greaterThan(0), lessThan(1)));
    await tester.pump(const Duration(milliseconds: 50));
    expect(progress(), greaterThan(0));
    expect(progress(), lessThan(1 / 3));
    await tester.pumpAndSettle();
    expectHidden(false);
    expectNumberOpacity(equals(1));
    expect(PreferencesController.getHideSensitiveData(), false);

    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(progress(), closeTo(1 / 3, 0.001));
    expect(find.text('15.5'), findsNothing);
    expect(find.text('60/180'), findsNothing);
    expect(find.text('9'), findsNothing);
    await tester.pump(const Duration(milliseconds: 140));
    expect(progress(), greaterThan(0));
    expect(progress(), lessThan(1 / 3));
    await tester.pumpAndSettle();
    expectHidden(true);
    expect(PreferencesController.getHideSensitiveData(), true);

    await tester.pumpWidget(const SizedBox.shrink());
    final nextSession = ProviderContainer();
    addTearDown(nextSession.dispose);
    expect(nextSession.read(hideSensitiveDataProvider), true);
  });

  testWidgets('number reveal respects reduced motion', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: FadeIn(child: Text('15.5')),
        ),
      ),
    );
    expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 1);
  });
}
