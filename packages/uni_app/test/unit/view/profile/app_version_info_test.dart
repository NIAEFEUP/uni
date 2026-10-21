import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uni/view/profile/widgets/app_version_info.dart';

import '../../../test_widget.dart';

void main() {
  group('AppVersionInfo', () {
    setUp(() async {
      await initTestEnvironment();
      PackageInfo.setMockInitialValues(
        appName: 'uni',
        packageName: 'pt.up.fe.ni.uni',
        version: '2.6.1',
        buildNumber: '534',
        buildSignature: '',
      );
    });

    testWidgets('shows the app version and build number', (tester) async {
      await tester.pumpWidget(testableWidget(const AppVersionInfo()));
      await tester.pumpAndSettle();

      expect(find.text('Estás a usar a uni 2.6.1 (534)'), findsOneWidget);
    });
  });
}
