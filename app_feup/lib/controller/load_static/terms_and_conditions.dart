import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

/// Returns the content of the Terms and Conditions file.
///
/// If this operation is unsuccessful, an error message is returned.
Future<String> readTermsAndConditions() async {
  if (await (Connectivity().checkConnectivity()) != ConnectionState.none) {
    try {
      final String url =
          'https://raw.githubusercontent.com/NIAEFEUP/project-schrodinger/develop/app_feup/assets/text/TermsAndConditions.md';
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
    await AppSharedPreferences.setTermsAndConditionsAcceptance(false);
    await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  }

  return currentHash != hash || !acceptance;
}

/// Accepts the current Terms and Conditions.
Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
}
