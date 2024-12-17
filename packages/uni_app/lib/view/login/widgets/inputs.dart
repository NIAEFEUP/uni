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

/// To delete if widget page accepted
/// Creates the widget for the user to keep signed in (save his data).
Widget createSaveDataCheckBox(
  BuildContext context,
  void Function() toggleSignedIn, {
  required bool keepSignedIn,
  Color? textColor,
}) {
  return CheckboxListTile(
    value: keepSignedIn,
    onChanged: (_) => toggleSignedIn(),
    title: Text(
      S.of(context).keep_login,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
    ),
    controlAffinity: ListTileControlAffinity.leading,
    contentPadding: const EdgeInsets.symmetric(horizontal: 36),
    checkboxShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

/// To delete if widget page accepted
Widget createAFLogInButton(
  MediaQueryData queryData,
  BuildContext context,
  void Function() login,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),
    onPressed: login,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          'assets/images/AAI.svg',
          height: 26,
        ),
        const SizedBox(width: 20),
        Text(
          S.of(context).login,
          style: const TextStyle(
            color: Color(0xFF303030),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.left,
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

/// To delete if widget page accepted
/// Displays terms and conditions
InkResponse createTermsAndConditionsButton(BuildContext context) {
  return InkResponse(
    onTap: () {
      _showTermsAndConditions(context);
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.fromLTRB(40, 14, 40, 14),
      child: RichText(
        text: TextSpan(
          text: S.of(context).agree_terms,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            decorationColor: Colors.white,
          ),
          children: [
            const TextSpan(
              text: ' ',
            ),
            TextSpan(
              text: S.of(context).terms,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

/// To delete if widget page accepted
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
