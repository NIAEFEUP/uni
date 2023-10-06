import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlWithToast(BuildContext context, String url) async {
  final validUrl = Uri.parse(url);
  if (url != '' && canLaunchUrl(validUrl) as bool) {
    await launchUrl(Uri.parse(url));
  } else {
    await ToastMessage.error(
      context,
      'Não conseguimos abrir o link',
    );
  }
}
