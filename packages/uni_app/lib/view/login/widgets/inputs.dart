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
    style: Theme.of(context).textTheme.titleMedium,
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
    cursorColor: Theme.of(context).colorScheme.onSecondary,
    decoration: textFieldDecoration(context, S.of(context).student_number),
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
    style: Theme.of(context).textTheme.titleMedium,
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
    cursorColor: Theme.of(context).colorScheme.onSecondary,
    validator: (value) =>
        value != null && value.isEmpty ? S.of(context).empty_text : null,
  );
}

/// Decoration for the username field.
InputDecoration textFieldDecoration(BuildContext context, String placeholder) {
  return InputDecoration(
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSecondary,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
    border: InputBorder.none,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
    ),
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
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
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSecondary,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 25, 0, 10),
    border: InputBorder.none,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
    ),
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,

    /// TO-DO change the Icon to a PhosphorIcon after the icons.dart is merged
    suffixIcon: IconButton(
      icon: Icon(
        obscurePasswordInput ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: toggleObscurePasswordInput,
    ),
  );
}
