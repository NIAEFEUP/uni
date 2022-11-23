import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/theme.dart';
import 'package:uni/view/login/widgets/inputs.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)));
    widgets.add(createForgetPasswordLink(context));
    widgets.add(
        Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 15)));
    widgets.add(createLogInButton(queryData, context, _login));
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
    ToastMessage.info(context, 'Pressione novamente para sair');
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
          createFacultyInput(context, faculties, setFaculties),
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),
          createUsernameInput(context, usernameController, usernameFocus, passwordFocus), 
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),
          createPasswordInput(context, passwordController, passwordFocus, _obscurePasswordInput, _toggleObscurePasswordInput, () => _login(context)),
          Padding(padding: EdgeInsets.only(bottom: queryData.size.height / 35)),

          createSaveDataCheckBox(_keepSignedIn, _setKeepSignedIn),
        ]),
      ),
    );
  }

  ///Creates the widget for when the user forgets the password
  Widget createForgetPasswordLink(BuildContext context){
    return InkWell(
      child: Center(
        child:Text("Esqueceu a palavra-passe?",
          style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(decoration: TextDecoration.underline, color: Colors.white))
      ),
        onTap: () => launchUrl(Uri.parse("https://self-id.up.pt/reset"))
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
                context, '/${DrawerItem.navPersonalArea.title}');
          } else if (status == RequestStatus.failed) {
            ToastMessage.error(context, 'O login falhou');
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
}
