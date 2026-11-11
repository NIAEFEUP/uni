import 'package:flutter_test/flutter_test.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/session/flows/federated/request.dart';

void main() {
  group('FederatedSessionUserInfo Tests', () {
    test('extracts username from nmec when available', () {
      final userInfo = UserInfo.fromJson({
        'sub': 'user-uuid-1234',
        'preferred_username': 'up202604370',
        'nmec': '202604370',
        'email': 'up202604370@edu.fe.up.pt',
        'ous': ['FEUP'],
      });

      final info = FederatedSessionUserInfo(userInfo);
      expect(info.username, equals('202604370'));
      expect(info.faculties, equals(['feup']));
    });

    test('falls back to preferred_username when nmec is absent', () {
      final userInfo = UserInfo.fromJson({
        'sub': 'user-uuid-5678',
        'preferred_username': 'up202609999',
        'email': 'applicant@gmail.com',
      });

      final info = FederatedSessionUserInfo(userInfo);
      expect(info.username, equals('up202609999'));
    });

    test(
      'falls back to email prefix when nmec and preferred_username are absent',
      () {
        final userInfo = UserInfo.fromJson({
          'sub': 'user-uuid-9999',
          'email': 'mairadomingos108@gmail.com',
        });

        final info = FederatedSessionUserInfo(userInfo);
        expect(info.username, equals('mairadomingos108'));
      },
    );

    test('falls back to sub when all other identifiers are absent', () {
      final userInfo = UserInfo.fromJson({'sub': 'user-uuid-9999'});

      final info = FederatedSessionUserInfo(userInfo);
      expect(info.username, equals('user-uuid-9999'));
    });

    test('extracts faculties from email domain when ous is absent', () {
      final userInfo = UserInfo.fromJson({
        'sub': 'user-uuid-1111',
        'preferred_username': 'up202401234',
        'email': 'student@edu.fcup.up.pt',
      });

      final info = FederatedSessionUserInfo(userInfo);
      expect(info.faculties, equals(['fcup']));
    });
  });
}
