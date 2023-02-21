import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni/view/common_widgets/toast_message.dart';

Future launchUrlWithToast(BuildContext context,link) async {
  if (await canLaunchUrl(Uri.parse(link))){
    Logger().i("Successfully launched this link");
    await launchUrl(Uri.parse(link));
  }else {
    Logger().i("Could not launch this link");
    ToastMessage.error(context, "Could not launch this link");
  }
}