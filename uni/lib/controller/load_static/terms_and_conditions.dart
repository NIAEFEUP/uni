import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

/// Returns the content of the Terms and Conditions remote file,
/// or the local one if the remote file is not available.
///
/// If this operation is unsuccessful, an error message is returned.
Future<String> fetchTermsAndConditions() async {
  return rootBundle.loadString('assets/text/TermsAndConditions.md');
}

/// Checks if the current Terms and Conditions have been accepted by the user,
/// by fetching the current terms, hashing them and comparing
/// with the stored hash.
/// Sets the acceptance to false if the terms have changed,
/// or true if they haven't.
/// Returns the updated value.
Future<bool> updateTermsAndConditionsAcceptancePreference() async {
  final hash = await AppSharedPreferences.getTermsAndConditionHash();
  final termsAndConditions = await fetchTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();

  if (hash == null) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(
      areAccepted: true,
    );
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return true;
  }

  if (currentHash != hash) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(
      areAccepted: false,
    );
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return false;
  }

  await AppSharedPreferences.setTermsAndConditionsAcceptance(areAccepted: true);
  return true;
}

/// Accepts the current Terms and Conditions.
Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await fetchTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(areAccepted: true);
}
