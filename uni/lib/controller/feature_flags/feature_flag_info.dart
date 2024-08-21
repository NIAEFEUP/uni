import 'package:flutter/material.dart';

abstract class GenericFeatureFlagInfo {
  const GenericFeatureFlagInfo({
    required this.code,
    required this.getName,
  });

  final String code;
  final String Function(BuildContext) getName;
}

class FeatureFlagInfo extends GenericFeatureFlagInfo {
  const FeatureFlagInfo({
    required super.code,
    required super.getName,
  });
}

class FeatureFlagGroupInfo extends GenericFeatureFlagInfo {
  const FeatureFlagGroupInfo({
    required super.code,
    required super.getName,
    required this.featureFlags,
  });

  final List<FeatureFlagInfo> featureFlags;
}
