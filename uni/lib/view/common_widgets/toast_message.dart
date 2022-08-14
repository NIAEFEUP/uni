import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

/// Provides feedback about an operation in a small popup
///
/// usage example: ToastMessage.display(context, toastMsg);
class ToastMessage {
  static const Color toastColor = Color.fromARGB(255, 100, 100, 100);
  static display(BuildContext context, String msg) {
    ToastContext().init(context);
    Toast.show(msg,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: toastColor,
        backgroundRadius: 16.0);
  }
}
