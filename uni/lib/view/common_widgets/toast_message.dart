import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Provides feedback about an operation in a small popup
///
/// usage example: ToastMessage.display(context, toastMsg);
class MessageToast extends StatelessWidget {
  final String message;
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final AlignmentGeometry? alignment;
  final dynamic elevation;

  const MessageToast(
      {Key? key,
      required this.message,
      this.color = Colors.white,
      required this.icon,
      this.iconColor = Colors.black,
      this.textColor = Colors.black,
      this.alignment = Alignment.bottomCenter,
      this.elevation = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: const EdgeInsets.all(50),
        alignment: alignment,
        backgroundColor: color,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        elevation: elevation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.all(10.0),
                child: Icon(
                  icon,
                  color: iconColor,
                )),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontStyle: FontStyle.normal, color: textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ToastMessage {
  static const Color toastErrorIconColor = Color.fromARGB(255, 241, 77, 98),
      toastErrorColor = Color.fromARGB(255, 252, 237, 238),
      toastSuccessIconColor = Color.fromARGB(255, 53, 210, 157),
      toastSuccessColor = Color.fromARGB(255, 234, 250, 246),
      toastWarningIconColor = Color.fromARGB(255, 244, 200, 98),
      toastWarningColor = Color.fromARGB(255, 252, 244, 222),
      toastInfoIconColor = Color.fromARGB(255, 40, 131, 229),
      toastInfoColor = Color.fromARGB(255, 211, 229, 249);

  static Future _displayDialog(BuildContext context, Widget mToast) {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (toastContext) {
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.of(toastContext).pop();
          });
          return mToast;
        });
  }

  static error(BuildContext context, String msg) => _displayDialog(
      context,
      MessageToast(
          message: msg,
          color: toastErrorColor,
          icon: CupertinoIcons.clear_circled_solid,
          iconColor: toastErrorIconColor));

  static success(BuildContext context, String msg) => _displayDialog(
      context,
      MessageToast(
          message: msg,
          color: toastSuccessColor,
          icon: CupertinoIcons.check_mark_circled_solid,
          iconColor: toastSuccessIconColor));

  static warning(BuildContext context, String msg) => _displayDialog(
      context,
      MessageToast(
          message: msg,
          color: toastWarningColor,
          icon: CupertinoIcons.exclamationmark_circle_fill,
          iconColor: toastWarningIconColor));

  static info(BuildContext context, String msg) => _displayDialog(
      context,
      MessageToast(
          message: msg,
          color: toastInfoColor,
          icon: CupertinoIcons.info_circle_fill,
          iconColor: toastInfoIconColor));
}
