// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../controller/session/federated/request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FederatedSessionRequest _$FederatedSessionRequestFromJson(
        Map<String, dynamic> json) =>
    FederatedSessionRequest(
      credential:
          Credential.fromJson(json['credential'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FederatedSessionRequestToJson(
        FederatedSessionRequest instance) =>
    <String, dynamic>{
      'credential': instance.credential.toJson(),
    };
