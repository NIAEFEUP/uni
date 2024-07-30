import 'package:json_annotation/json_annotation.dart';
import 'package:openid_client/openid_client.dart';
import 'package:uni/controller/session/federated/request.dart';
import 'package:uni/controller/session/session.dart';
import 'package:url_launcher/url_launcher.dart';

part '../../../generated/controller/session/federated/session.g.dart';

@JsonSerializable(explicitToJson: true)
class FederatedSession extends Session {
  FederatedSession({
    required super.username,
    required super.cookies,
    required super.faculties,
    required this.credential,
  });

  // Serialization logic

  factory FederatedSession.fromJson(Map<String, dynamic> json) =>
      _$FederatedSessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FederatedSessionToJson(this);

  final Credential credential;

  @override
  FederatedSessionRequest createRefreshRequest() => FederatedSessionRequest(
        credential: credential,
      );

  @override
  Future<void> onClose() async {
    await super.onClose();

    final homeUri = Uri.parse('pt.up.fe.ni.uni://home');
    final logoutUri = credential.generateLogoutUrl(redirectUri: homeUri);

    if (logoutUri == null) {
      throw Exception('Failed to generate logout url');
    }

    await launchUrl(logoutUri);
    // await openUrl(logoutUri);
  }
}
