import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ToastMessage {
  static display(BuildContext context, String msg) {
    Toast.show(
      msg,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      backgroundRadius: 16.0,
      textColor: Theme.of(context).textTheme.headline1.color,
    );
  }
}
