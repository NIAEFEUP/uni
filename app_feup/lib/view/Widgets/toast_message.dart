import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastMessage {
  static const Color toastColor = Color.fromARGB(255, 100, 100, 100);
  static display(BuildContext context, String msg) {
    Toast.show(
      msg,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: toastColor,
      backgroundRadius: 16.0,
      textColor: Colors.white,
    );
  }
}
