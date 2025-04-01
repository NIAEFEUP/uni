import 'package:uni/controller/feature_flags/feature_flag_info.dart';
import 'package:uni/generated/l10n.dart';

List<GenericFeatureFlagInfo> featureFlagTable = [
  FeatureFlagInfo(
    code: 'library_modules',
    getName: (context) => S.of(context).library_modules,
  ),
  FeatureFlagGroupInfo(
    code: 'library',
    getName: (context) => S.of(context).library_modules,
    featureFlags: [
      FeatureFlagInfo(
        code: 'library_occupation',
        getName: (context) => S.of(context).library_modules,
      ),
      FeatureFlagInfo(
        code: 'library_floors',
        getName: (context) => S.of(context).library_modules,
      ),
    ],
  ),
];
