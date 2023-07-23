import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

/// Returns the content of the Terms and Conditions remote file,
/// or the local one if the remote file is not available.
///
/// If this operation is unsuccessful, an error message is returned.
Future<String> fetchTermsAndConditions() async {
  if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
    try {
      const String url = 'https://raw.githubusercontent.com/NIAEFEUP/'
          'uni/develop/uni/assets/text/TermsAndConditions.md';
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      Logger().e('Failed to fetch Terms and Conditions: ${e.toString()}');
    }
  }

  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    Logger().e('Failed to read Terms and Conditions: ${e.toString()}');
    return 'Não foi possível carregar os Termos e Condições. '
        'Por favor tente mais tarde.';
  }
}

/// Checks if the current Terms and Conditions have been accepted by the user,
/// by fetching the current terms, hashing them and comparing with the stored hash.
/// Sets the acceptance to false if the terms have changed, or true if they haven't.
/// Returns the updated value.
Future<bool> updateTermsAndConditionsAcceptancePreference() async {
  final hash = await AppSharedPreferences.getTermsAndConditionHash();
  final termsAndConditions = await fetchTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();

  if (hash == null) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return true;
  }

  if (currentHash != hash) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(false);
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return false;
  }

  await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
  return true;
}

/// Accepts the current Terms and Conditions.
Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await fetchTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
}
