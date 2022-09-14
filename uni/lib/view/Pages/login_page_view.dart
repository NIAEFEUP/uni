import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/utils/constants.dart' as constants;
import 'package:uni/view/Widgets/faculties_multiselect.dart';
import 'package:uni/view/Widgets/terms_and_conditions.dart';
import 'package:uni/view/Widgets/toast_message.dart';
import 'package:uni/view/theme.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

/// Manages the 'login section' view.
class LoginPageViewState extends State<LoginPageView> {
  List<String> faculties = [
    'feup'
  ]; // May choose more than one faculty in the dropdown.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  static final FocusNode usernameFocus = FocusNode();
  static final FocusNode passwordFocus = FocusNode();

  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static bool _exitApp = false;
  bool _keepSignedIn = true;
  bool _obscurePasswordInput = true;

  void _login(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (store.state.content['loginStatus'] != RequestStatus.busy &&
        _formKey.currentState!.validate()) {
      final user = usernameController.text.trim();
      final pass = passwordController.text.trim();
      store.dispatch(login(user, pass, faculties, _keepSignedIn,
          usernameController, passwordController));
    }
  }

  /// Updates the list of faculties
  /// based on the options the user selected (used as a callback)
  void setFaculties(faculties) {
    setState(() {
      this.faculties = faculties;
    });
  }

  /// Tracks if the user wants to keep signed in (has a
  /// checkmark on the button).
  void _setKeepSignedIn(value) {
    setState(() {
      _keepSignedIn = value;
    });
  }

  /// Makes the password input view hidden.
  void _toggleObscurePasswordInput() {
    setState(() {
      _obscurePasswordInput = !_obscurePasswordInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);

    return Theme(
        data: applicationLightTheme.copyWith(
          // The handle color is not applying due to a Flutter bug:
          // https://github.com/flutter/flutter/issues/74890
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white, selectionHandleColor: Colors.white),
          checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(darkRed),
              fillColor: MaterialStateProperty.all(Colors.white)),
        ),
        child: Builder(
            builder: (themeContext) => Scaffold(
                backgroundColor: darkRed,
                body: WillPopScope(
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: queryData.size.width / 8,
                            right: queryData.size.width / 8),
                        child: ListView(
                          children: getWidgets(themeContext, queryData),
                        )),
                    onWillPop: () => onWillPop(themeContext)))));
  }

  List<Widget> getWidgets(BuildContext context, MediaQueryData queryData) {
    final List<Widget> widgets = [];

    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 20)));
    widgets.add(createTitle(queryData, context));
    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)));
    widgets.add(getLoginForm(queryData, context));
    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 15)));
    widgets.add(createLogInButton(queryData, context));
    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)));
    widgets.add(createStatusWidget(context));
    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)));
    widgets.add(createSafeLoginButton(context));
    return widgets;
  }

  /// Delay time before the user leaves the app
  Future<void> exitAppWaiter() async {
    _exitApp = true;
    await Future.delayed(const Duration(seconds: 2));
    _exitApp = false;
  }

  /// If the user tries to leave, displays a quick prompt for him to confirm.
  /// If this is already the second time, the user leaves the app.
  Future<bool> onWillPop(BuildContext context) {
    if (_exitApp) {
      return Future.value(true);
    }
    ToastMessage.display(context, 'Pressione novamente para sair');
    exitAppWaiter();
    return Future.value(false);
  }

  /// Creates the title for the login menu.
  Widget createTitle(queryData, context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: Column(children: [
          SizedBox(
              width: 100.0,
              child: SvgPicture.asset(
                'assets/images/logo_dark.svg',
                color: Colors.white,
              )),
        ]));
  }

  /// Creates the widgets for the user input fields.
  Widget getLoginForm(MediaQueryData queryData, BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(children: [
          createFacultyInput(context),
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),
          createUsernameInput(context),
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),
          createPasswordInput(),
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),
          createSaveDataCheckBox()
        ]),
      ),
    );
  }

  /// Creates the widget for the user to choose their faculty
  Widget createFacultyInput(BuildContext context) {
    return FacultiesMultiselect(faculties, setFaculties);
  }

  /// Creates the widget for the username input.
  Widget createUsernameInput(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 20),
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      controller: usernameController,
      focusNode: usernameFocus,
      onFieldSubmitted: (term) {
        usernameFocus.unfocus();
        FocusScope.of(context).requestFocus(passwordFocus);
      },
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.left,
      decoration: textFieldDecoration('número de estudante'),
      validator: (String? value) =>
          value!.isEmpty ? 'Preenche este campo' : null,
    );
  }

  /// Creates the widget for the password input.
  Widget createPasswordInput() {
    return TextFormField(
        style: const TextStyle(color: Colors.white, fontSize: 20),
        enableSuggestions: false,
        autocorrect: false,
        autofocus: false,
        controller: passwordController,
        focusNode: passwordFocus,
        onFieldSubmitted: (term) {
          passwordFocus.unfocus();
          _login(context);
        },
        textInputAction: TextInputAction.done,
        obscureText: _obscurePasswordInput,
        enableInteractiveSelection: !_obscurePasswordInput,
        textAlign: TextAlign.left,
        decoration: passwordFieldDecoration('palavra-passe'),
        validator: (String? value) =>
            value != null && value.isEmpty ? 'Preenche este campo' : null);
  }

  /// Creates the widget for the user to keep signed in (save his data).
  Widget createSaveDataCheckBox() {
    return CheckboxListTile(
      value: _keepSignedIn,
      onChanged: _setKeepSignedIn,
      title: const Text(
        'Manter sessão iniciada',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.w300),
      ),
    );
  }

  /// Creates the widget for the user to confirm the inputted login info
  Widget createLogInButton(queryData, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: queryData.size.width / 7, right: queryData.size.width / 7),
      child: SizedBox(
        height: queryData.size.height / 16,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            primary: Colors.white,
          ),
          onPressed: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
            _login(context);
          },
          child: Text('Entrar',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }

  /// Creates a widget for the user login depending on the status of his login.
  Widget createStatusWidget(BuildContext context) {
    return StoreConnector<AppState, RequestStatus?>(
        converter: (store) => store.state.content['loginStatus'],
        onWillChange: (oldStatus, status) {
          if (status == RequestStatus.successful &&
              StoreProvider.of<AppState>(context)
                  .state
                  .content['session']
                  .authenticated) {
            Navigator.pushReplacementNamed(
                context, '/${constants.navPersonalArea}');
          } else if (status == RequestStatus.failed) {
            ToastMessage.display(context, 'O login falhou');
          }
        },
        builder: (context, status) {
          switch (status) {
            case RequestStatus.busy:
              return const SizedBox(
                height: 60.0,
                child: Center(
                    child: CircularProgressIndicator(color: Colors.white)),
              );
            default:
              return Container();
          }
        });
  }

  /// Decoration for the username field.
  InputDecoration textFieldDecoration(String placeholder) {
    return InputDecoration(
        hintStyle: const TextStyle(color: Colors.white),
        errorStyle: const TextStyle(
          color: Colors.white70,
        ),
        hintText: placeholder,
        contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3)));
  }

  /// Decoration for the password field.
  InputDecoration passwordFieldDecoration(String placeholder) {
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
            _obscurePasswordInput ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _toggleObscurePasswordInput,
          color: Colors.white,
        ));
  }

  /// Displays terms and conditions if the user is
  /// logging in for the first time.
  createSafeLoginButton(BuildContext context) {
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
                  fontSize: 17.0,
                  fontWeight: FontWeight.w300),
            )));
  }

  /// Displays 'Terms and conditions' section.
  Future<void> _showLoginDetails(BuildContext context) async {
    showDialog(
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
        });
  }
}
