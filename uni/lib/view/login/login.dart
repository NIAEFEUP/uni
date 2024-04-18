import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/login_exceptions.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/home/widgets/exit_app_dialog.dart';
import 'package:uni/view/login/widgets/inputs.dart';
import 'package:uni/view/theme.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

/// Manages the 'login section' view.
class LoginPageViewState extends State<LoginPageView> {
  static final FocusNode usernameFocus = FocusNode();
  static final FocusNode passwordFocus = FocusNode();

  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _keepSignedIn = true;
  bool _obscurePasswordInput = true;
  bool _loggingIn = false;

  Future<void> _login(BuildContext context) async {
    final stateProviders = StateProviders.fromContext(context);
    final sessionProvider = stateProviders.sessionProvider;

    if (!_loggingIn && _formKey.currentState!.validate()) {
      final user = usernameController.text.trim();
      final pass = passwordController.text.trim();

      try {
        setState(() {
          _loggingIn = true;
        });
        await sessionProvider.postAuthentication(
          context,
          user,
          pass,
          persistentSession: _keepSignedIn,
        );

        usernameController.clear();
        passwordController.clear();

        if (context.mounted) {
          await Navigator.pushReplacementNamed(
            context,
            '/${NavigationItem.navPersonalArea.route}',
          );
          setState(() {
            _loggingIn = false;
          });
        }
      } catch (error, stackTrace) {
        setState(() {
          _loggingIn = false;
        });
        if (error is ExpiredCredentialsException) {
          updatePasswordDialog();
        } else if (error is InternetStatusException) {
          if (context.mounted) {
            unawaited(ToastMessage.warning(context, error.message));
          }
        } else if (error is WrongCredentialsException) {
          if (context.mounted) {
            unawaited(ToastMessage.error(context, error.message));
          }
        } else {
          Logger().e(error, stackTrace: stackTrace);
          unawaited(Sentry.captureException(error, stackTrace: stackTrace));
          if (context.mounted) {
            unawaited(ToastMessage.error(context, S.of(context).failed_login));
          }
        }
      }
    }
  }

  /// Tracks if the user wants to keep signed in (has a
  /// checkmark on the button).
  void _setKeepSignedIn({bool? value}) {
    if (value == null) {
      return;
    }
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
    final queryData = MediaQuery.of(context);

    return Theme(
      data: applicationLightTheme.copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: darkRed,
          body: BackButtonExitWrapper(
            child: Padding(
              padding: EdgeInsets.only(
                left: queryData.size.width / 8,
                right: queryData.size.width / 8,
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 20,
                    ),
                  ),
                  createTitle(queryData, context),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 35,
                    ),
                  ),
                  getLoginForm(queryData, context),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 35,
                    ),
                  ),
                  createForgetPasswordLink(context),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 15,
                    ),
                  ),
                  createLogInButton(queryData, context, _login),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 35,
                    ),
                  ),
                  createStatusWidget(context),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: queryData.size.height / 35,
                    ),
                  ),
                  createSafeLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates the title for the login menu.
  Widget createTitle(MediaQueryData queryData, BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: queryData.size.width / 8,
        minHeight: queryData.size.height / 6,
      ),
      child: Column(
        children: [
          SizedBox(
            width: 100,
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates the widgets for the user input fields.
  Widget getLoginForm(MediaQueryData queryData, BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: queryData.size.height / 35),
            ),
            createUsernameInput(
              context,
              usernameController,
              usernameFocus,
              passwordFocus,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: queryData.size.height / 35),
            ),
            createPasswordInput(
              context,
              passwordController,
              passwordFocus,
              _toggleObscurePasswordInput,
              () => _login(context),
              obscurePasswordInput: _obscurePasswordInput,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: queryData.size.height / 35),
            ),
            createSaveDataCheckBox(
              context,
              _setKeepSignedIn,
              keepSignedIn: _keepSignedIn,
            ),
          ],
        ),
      ),
    );
  }

  ///Creates the widget for when the user forgets the password
  Widget createForgetPasswordLink(BuildContext context) {
    return InkWell(
      child: Center(
        child: Text(
          S.of(context).forgot_password,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                decoration: TextDecoration.underline,
                color: Colors.white,
              ),
        ),
      ),
      onTap: () => launchUrlWithToast(context, 'https://self-id.up.pt/reset'),
    );
  }

  /// Creates a widget for the user login depending on the status of his login.
  Widget createStatusWidget(BuildContext context) {
    return Consumer<SessionProvider>(
      builder: (context, sessionProvider, _) {
        if (_loggingIn) {
          return const SizedBox(
            height: 60,
            child:
                Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        return Container();
      },
    );
  }

  void updatePasswordDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).expired_password),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).pass_change_request,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).change_prompt,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(S.of(context).change),
              onPressed: () =>
                  launchUrlWithToast(context, 'https://self-id.up.pt/password'),
            ),
          ],
        );
      },
    );
  }
}
