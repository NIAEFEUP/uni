import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

/// Creates the widget for the username input.
Widget createUsernameInput(
  BuildContext context,
  TextEditingController usernameController,
  FocusNode usernameFocus,
  FocusNode passwordFocus,
) {
  return TextFormField(
    style: const TextStyle(fontSize: 14),
    enableSuggestions: false,
    autocorrect: false,
    controller: usernameController,
    focusNode: usernameFocus,
    onFieldSubmitted: (term) {
      usernameFocus.unfocus();
      FocusScope.of(context).requestFocus(passwordFocus);
    },
    textInputAction: TextInputAction.next,
    textAlign: TextAlign.left,
    decoration: textFieldDecoration(
      S.of(context).student_number,
      textColor: Theme.of(context).indicatorColor,
    ),
    validator: (value) => value!.isEmpty ? S.of(context).empty_text : null,
  );
}

Widget createPasswordInput(
  BuildContext context,
  TextEditingController passwordController,
  FocusNode passwordFocus,
  void Function() toggleObscurePasswordInput,
  void Function() login, {
  required bool obscurePasswordInput,
}) {
  return TextFormField(
    style: const TextStyle(fontSize: 14),
    enableSuggestions: false,
    autocorrect: false,
    controller: passwordController,
    focusNode: passwordFocus,
    onFieldSubmitted: (term) {
      passwordFocus.unfocus();
      login();
    },
    textInputAction: TextInputAction.done,
    obscureText: obscurePasswordInput,
    textAlign: TextAlign.left,
    decoration: passwordFieldDecoration(
      context,
      S.of(context).password,
      toggleObscurePasswordInput,
      obscurePasswordInput: obscurePasswordInput,
    ),
    validator: (value) =>
        value != null && value.isEmpty ? S.of(context).empty_text : null,
  );
}

/// Decoration for the username field.
InputDecoration textFieldDecoration(
  String placeholder, {
  required Color textColor,
}) {
  return InputDecoration(
    hintStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
    border: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2),
    ),
  );
}

/// Decoration for the password field.
InputDecoration passwordFieldDecoration(
  BuildContext context,
  String placeholder,
  void Function() toggleObscurePasswordInput, {
  required bool obscurePasswordInput,
}) {
  return InputDecoration(
    hintStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).indicatorColor,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
    border: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2),
    ),
    suffixIcon: IconButton(
      icon: Icon(
        obscurePasswordInput ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: toggleObscurePasswordInput,
    ),
  );
}
