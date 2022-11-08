import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

/// Provides feedback about an operation in a small popup
///
/// usage example: ToastMessage.display(context, toastMsg);
class ToastMessage {
  static const Color toastErrorColor = Color.fromARGB(255, 100, 100, 100),
                     toastSuccessColor = Color.fromARGB(255, 0, 250, 154);

  static errorMessage(BuildContext context, String msg){
    ToastContext().init(context);
    Toast.show(msg,
      duration: Toast.lengthLong,
      gravity: Toast.bottom,
      backgroundColor: toastErrorColor,
      backgroundRadius: 16.0);
  }

  static successMessage(BuildContext context, String msg){
    ToastContext().init(context);
    Toast.show(msg,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: toastSuccessColor,
        backgroundRadius: 16.0);
  }
}
