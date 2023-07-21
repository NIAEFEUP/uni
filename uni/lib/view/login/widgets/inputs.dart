import 'package:flutter/material.dart';
import 'package:uni/view/about/widgets/terms_and_conditions.dart';
import 'package:uni/view/login/widgets/faculties_multiselect.dart';

/// Creates the widget for the user to choose their faculty
Widget createFacultyInput(
  BuildContext context,
  List<String> faculties,
  setFaculties,
) {
  return FacultiesMultiselect(faculties, setFaculties);
}

/// Creates the widget for the username input.
Widget createUsernameInput(
  BuildContext context,
  TextEditingController usernameController,
  FocusNode usernameFocus,
  FocusNode passwordFocus,
) {
  return TextFormField(
    style: const TextStyle(color: Colors.white, fontSize: 20),
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
    decoration: textFieldDecoration('número de estudante'),
    validator: (String? value) => value!.isEmpty ? 'Preenche este campo' : null,
  );
}

Widget createPasswordInput(
  BuildContext context,
  TextEditingController passwordController,
  FocusNode passwordFocus,
  bool obscurePasswordInput,
  Function toggleObscurePasswordInput,
  Function login,
) {
  return TextFormField(
    style: const TextStyle(color: Colors.white, fontSize: 20),
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
      'palavra-passe',
      obscurePasswordInput,
      toggleObscurePasswordInput,
    ),
    validator: (String? value) =>
        value != null && value.isEmpty ? 'Preenche este campo' : null,
  );
}

/// Creates the widget for the user to keep signed in (save his data).
Widget createSaveDataCheckBox(bool keepSignedIn, setKeepSignedIn) {
  return CheckboxListTile(
    value: keepSignedIn,
    onChanged: setKeepSignedIn,
    title: const Text(
      'Manter sessão iniciada',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}

/// Creates the widget for the user to confirm the inputted login info
Widget createLogInButton(queryData, BuildContext context, login) {
  return Padding(
    padding: EdgeInsets.only(
      left: queryData.size.width / 7,
      right: queryData.size.width / 7,
    ),
    child: SizedBox(
      height: queryData.size.height / 16,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
          login(context);
        },
        child: Text(
          'Entrar',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

/// Decoration for the username field.
InputDecoration textFieldDecoration(String placeholder) {
  return InputDecoration(
    hintStyle: const TextStyle(color: Colors.white),
    errorStyle: const TextStyle(
      color: Colors.white70,
    ),
    hintText: placeholder,
    contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    border: const UnderlineInputBorder(),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 3),
    ),
  );
}

/// Decoration for the password field.
InputDecoration passwordFieldDecoration(
  String placeholder,
  bool obscurePasswordInput,
  toggleObscurePasswordInput,
) {
  final genericDecoration = textFieldDecoration(placeholder);
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
      color: Colors.white,
    ),
  );
}

/// Displays terms and conditions if the user is
/// logging in for the first time.
InkResponse createSafeLoginButton(BuildContext context) {
  return InkResponse(
    onTap: () {
      _showLoginDetails(context);
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Container(
      padding: const EdgeInsets.all(8),
      child: const Text(
        '''Ao entrares confirmas que concordas com estes Termos e Condições''',
        textAlign: TextAlign.center,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
  );
}

/// Displays 'Terms and conditions' section.
Future<void> _showLoginDetails(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Termos e Condições'),
        content: const SingleChildScrollView(child: TermsAndConditions()),
        actions: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
