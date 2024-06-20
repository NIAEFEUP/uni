import 'dart:async';

import 'package:flutter/gestures.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
          usernameController.clear();
          passwordController.clear();
          await Navigator.pushReplacementNamed(
            context,
            '/${NavigationItem.navPersonalArea.route}',
          );
          setState(() {
            _loggingIn = false;
          });
        }
      } catch (err, st) {
        setState(() {
          _loggingIn = false;
        });
        if (err is ExpiredCredentialsException) {
          _updatePasswordDialog();
        } else if (err is InternetStatusException) {
          if (context.mounted) {
            unawaited(ToastMessage.warning(context, err.message));
          }
        } else if (err is WrongCredentialsException) {
          if (context.mounted) {
            unawaited(ToastMessage.error(context, err.message));
          }
        } else {
          Logger().e(err, stackTrace: st);
          unawaited(Sentry.captureException(err, stackTrace: st));
          if (context.mounted) {
            unawaited(ToastMessage.error(context, S.of(context).failed_login));
          }
        }
      }
    }
  }

  Future<void> _falogin(BuildContext context) async {
    final stateProviders = StateProviders.fromContext(context);
    final sessionProvider = stateProviders.sessionProvider;

    try {
      setState(() {
        _loggingIn = true;
      });
      await sessionProvider.federatedAuthentication(
        context,
        persistentSession: _keepSignedIn,
      );
      setState(() {
        _loggingIn = false;
      });
    } catch (err, _) {
      await closeInAppWebView();
      Logger().e('Failed to authenticate');
      if (context.mounted) {
        unawaited(ToastMessage.error(context, 'Failed to authenticate'));
      }
    }
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
              child: Column(
                children: [
                  SizedBox(height: queryData.size.height / 20),
                  SizedBox(
                    width: 100,
                    // TODO(thePeras): Divide into two svgs to add color
                    child: SvgPicture.asset(
                      'assets/images/logo_dark.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(height: queryData.size.height / 5),
                  createAFLogInButton(queryData, context, _falogin),
                  const SizedBox(height: 10),
                  createSaveDataCheckBox(
                    context,
                    () {
                      setState(() {
                        _keepSignedIn = !_keepSignedIn;
                      });
                    },
                    keepSignedIn: _keepSignedIn,
                  ),
                  createLink(
                    context,
                    S.of(context).try_different_login,
                    _showAlternativeLogin,
                  ),
                  SizedBox(height: queryData.size.height / 5),
                  createTermsAndConditionsButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Creates the widget for when the user forgets the password
  Widget createLink(BuildContext context, String text, void Function() onTap) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              decoration: TextDecoration.underline,
              color: Colors.white,
              decorationColor: Colors.white,
              decorationThickness: 2,
            ),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      ),
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

  Future<void> _showAlternativeLogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).login_with_credentials),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      createUsernameInput(
                        context,
                        usernameController,
                        usernameFocus,
                        passwordFocus,
                      ),
                      const SizedBox(height: 20),
                      createPasswordInput(
                        context,
                        passwordController,
                        passwordFocus,
                        () {
                          setState(() {
                            _obscurePasswordInput = !_obscurePasswordInput;
                          });
                        },
                        () => _login(context),
                        obscurePasswordInput: _obscurePasswordInput,
                      ),
                      const SizedBox(height: 20),
                      createSaveDataCheckBox(
                        context,
                        () {
                          setState(() {
                            _keepSignedIn = !_keepSignedIn;
                          });
                        },
                        keepSignedIn: _keepSignedIn,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text(S.of(context).login),
            ),
          ],
        );
      },
    );
  }

  void _updatePasswordDialog() {
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
