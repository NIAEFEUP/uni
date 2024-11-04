import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';

/// Creates the widget for the username input.
Widget createUsernameInput(
  BuildContext context,
  TextEditingController usernameController,
  FocusNode usernameFocus,
  FocusNode passwordFocus,
) {
  return TextFormField(
    style: const TextStyle(fontSize: 20),
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
    style: const TextStyle(fontSize: 20),
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

/// Creates the widget for the user to keep signed in (save his data).
Widget createSaveDataCheckBox(
  BuildContext context,
  void Function() toogleSignedIn, {
  required bool keepSignedIn,
  Color? textColor,
}) {
  return CheckboxListTile(
    value: keepSignedIn,
    onChanged: (_) => toogleSignedIn(),
    title: Text(
      S.of(context).keep_login,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

Widget createAFLogInButton(
  MediaQueryData queryData,
  BuildContext context,
  void Function() login,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    onPressed: login,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/AAI.svg',
          height: 35,
        ),
        Text(
          S.of(context).login,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

/// Decoration for the username field.
InputDecoration textFieldDecoration(
  String placeholder, {
  required Color textColor,
}) {
  return InputDecoration(
    hintStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w300,
      color: textColor,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
  final genericDecoration = textFieldDecoration(
    placeholder,
    textColor: Theme.of(context).indicatorColor,
  );
  return InputDecoration(
    hintStyle: genericDecoration.hintStyle,
    errorStyle: genericDecoration.errorStyle,
    hintText: genericDecoration.hintText,
    contentPadding: genericDecoration.contentPadding,
    border: genericDecoration.border,
    focusedBorder: genericDecoration.focusedBorder,
    suffixIcon: IconButton(
      icon: Icon(
        obscurePasswordInput ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: toggleObscurePasswordInput,
    ),
  );
}

/// Displays terms and conditions
InkResponse createTermsAndConditionsButton(BuildContext context) {
  return InkResponse(
    onTap: () {
      _showTermsAndConditions(context);
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        S.of(context).agree_terms,
        textAlign: TextAlign.center,
        style: const TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          decorationColor: Colors.white,
        ),
      ),
    ),
  );
}

/// Displays 'Terms and conditions' section.
Future<void> _showTermsAndConditions(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).terms),
        content: const SingleChildScrollView(child: TermsAndConditions()),
        actions: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
