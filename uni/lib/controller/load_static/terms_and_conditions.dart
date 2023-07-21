import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

/// Returns the content of the Terms and Conditions file.
///
/// If this operation is unsuccessful, an error message is returned.
Future<String> readTermsAndConditions() async {
  if (await Connectivity().checkConnectivity() != ConnectivityResult.none) {
    try {
      const url =
          'https://raw.githubusercontent.com/NIAEFEUP/project-schrodinger/develop/uni/assets/text/TermsAndConditions.md';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      Logger().e('Failed to fetch Terms and Conditions: $e');
    }
  }
  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    Logger().e('Failed to read Terms and Conditions: $e');
    return 'Não foi possível carregar os Termos e Condições. '
        'Por favor tente mais tarde.';
  }
}

/// Checks if the current Terms and Conditions have been accepted by the user.
///
/// Returns true if the current Terms and Conditions have been accepted,
/// false otherwise.
Future<bool> updateTermsAndConditionsAcceptancePreference() async {
  final hash = await AppSharedPreferences.getTermsAndConditionHash();
  final acceptance = await AppSharedPreferences.areTermsAndConditionsAccepted();
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  if (hash == null) {
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
    return true;
  }

  if (currentHash != hash) {
    await AppSharedPreferences.setTermsAndConditionsAcceptance(
      areAccepted: false,
    );
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  }

  return currentHash != hash || !acceptance;
}

/// Accepts the current Terms and Conditions.
Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(areAccepted: true);
}
