import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_common_ui/common/toast_message.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlWithToast(BuildContext context, String url) async {
  final validUrl = Uri.parse(url);
  final canLaunch = url != '' && await canLaunchUrl(validUrl);

  if (!context.mounted) {
    return;
  }

  if (canLaunch) {
    await launchUrl(validUrl);
  } else {
    await ToastMessage.error(
      context,
      S.of(context).no_link,
    );
  }
}
