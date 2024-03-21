import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Provides feedback about an operation in a small popup
///
/// usage example: ToastMessage.display(context, toastMsg);
class MessageToast extends StatelessWidget {
  const MessageToast({
    required this.message,
    required this.icon,
    super.key,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    this.alignment = Alignment.bottomCenter,
    this.elevation = 0.0,
  });
  final String message;
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;
  final AlignmentGeometry? alignment;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use, see #1210
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: const EdgeInsets.all(50),
        alignment: alignment,
        backgroundColor: color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        elevation: elevation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontStyle: FontStyle.normal, color: textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToastMessage {
  static const Color toastErrorIconColor = Color.fromARGB(255, 241, 77, 98);
  static const Color toastErrorColor = Color.fromARGB(255, 252, 237, 238);
  static const Color toastSuccessIconColor = Color.fromARGB(255, 53, 210, 157);
  static const Color toastSuccessColor = Color.fromARGB(255, 234, 250, 246);
  static const Color toastWarningIconColor = Color.fromARGB(255, 244, 200, 98);
  static const Color toastWarningColor = Color.fromARGB(255, 252, 244, 222);
  static const Color toastInfoIconColor = Color.fromARGB(255, 40, 131, 229);
  static const Color toastInfoColor = Color.fromARGB(255, 211, 229, 249);

  static Future<void> _displayDialog(BuildContext context, Widget mToast) {
    return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      builder: (toastContext) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(toastContext).pop();
        });
        return mToast;
      },
    );
  }

  static Future<void> error(BuildContext context, String msg) => _displayDialog(
        context,
        MessageToast(
          message: msg,
          color: toastErrorColor,
          icon: CupertinoIcons.clear_circled_solid,
          iconColor: toastErrorIconColor,
        ),
      );

  static Future<void> success(BuildContext context, String msg) =>
      _displayDialog(
        context,
        MessageToast(
          message: msg,
          color: toastSuccessColor,
          icon: CupertinoIcons.check_mark_circled_solid,
          iconColor: toastSuccessIconColor,
        ),
      );

  static Future<void> warning(BuildContext context, String msg) =>
      _displayDialog(
        context,
        MessageToast(
          message: msg,
          color: toastWarningColor,
          icon: CupertinoIcons.exclamationmark_circle_fill,
          iconColor: toastWarningIconColor,
        ),
      );

  static Future<void> info(BuildContext context, String msg) => _displayDialog(
        context,
        MessageToast(
          message: msg,
          color: toastInfoColor,
          icon: CupertinoIcons.info_circle_fill,
          iconColor: toastInfoIconColor,
        ),
      );
}
