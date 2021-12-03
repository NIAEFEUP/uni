import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

Future<String> readTermsAndConditions() async {
  if (await (Connectivity().checkConnectivity()) != ConnectionState.none) {
    try {
      final String url = 'https://pastebin.com/raw/eCMbHLPD';
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {}
  }
  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    return 'Não foi possível carregar os Termos e Condições. '
        'Por favor tente mais tarde.';
  }
}

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

Future<void> acceptTermsAndConditions() async {
  final termsAndConditions = await readTermsAndConditions();
  final currentHash = md5.convert(utf8.encode(termsAndConditions)).toString();
  await AppSharedPreferences.setTermsAndConditionHash(currentHash);
  await AppSharedPreferences.setTermsAndConditionsAcceptance(true);
}
