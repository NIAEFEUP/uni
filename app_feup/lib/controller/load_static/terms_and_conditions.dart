import 'package:flutter/services.dart' show rootBundle;

Future<String> readTermsAndConditions() async {
  try {
    return await rootBundle.loadString('assets/text/TermsAndConditions.md');
  } catch (e) {
    return 'Could not load terms and conditions. Please try again later';
  }
}
