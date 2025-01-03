import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni_ui/theme.dart';

/// Creates the widget for the username input.
Widget createUsernameInput(
  BuildContext context,
  TextEditingController usernameController,
  FocusNode usernameFocus,
  FocusNode passwordFocus,
) {
  return TextFormField(
    style: lightTheme.textTheme.titleMedium,
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
    style: lightTheme.textTheme.titleMedium,
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
    hintStyle: lightTheme.textTheme.titleMedium?.copyWith(
      color: const Color(0xFF3C0A0E),
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
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
    hintStyle: lightTheme.textTheme.titleMedium?.copyWith(
      color: const Color(0xFF3C0A0E),
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 25, 0, 0),
    border: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2),
    ),

    /// TO-DO change the Icon to a PhosphorIcon after the icons.dart is merged
    suffixIcon: IconButton(
      icon: Icon(
        obscurePasswordInput ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: toggleObscurePasswordInput,
    ),
  );
}
