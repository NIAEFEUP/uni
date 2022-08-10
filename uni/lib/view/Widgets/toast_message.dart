import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static const Color toastColor = Color.fromARGB(255, 100, 100, 100);
  static const Color errorToastColor = Colors.redAccent;
  static const Color successToastColor = Colors.greenAccent;
 
  static Widget errorToast(String msg) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(msg),
          ],
        ),
      );
  
  static Widget successToast(String msg) => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.greenAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(msg),
          ],
        ),
      );
  
  void displayErrorToast(BuildContext context, String msg) {
    FToast().init(context);
    FToast().showToast(child: errorToast(msg), gravity: ToastGravity.BOTTOM);
  }
  
  void displaySuccessToast(BuildContext context, String msg) {
    FToast().init(context);
    FToast().showToast(child: successToast(msg), gravity: ToastGravity.BOTTOM);
  }
  
  static display(BuildContext context, String msg) {
    ToastContext().init(context);
    Toast.show(msg,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: toastColor,
        backgroundRadius: 16.0);
  }
}
