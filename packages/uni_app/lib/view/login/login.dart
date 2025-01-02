import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/app_links/uni_app_links.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/exception.dart';
import 'package:uni/session/flows/credentials/initiator.dart';
import 'package:uni/session/flows/federated/initiator.dart';
import 'package:uni/utils/constants.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/toast_message.dart';
import 'package:uni/view/home/widgets/exit_app_dialog.dart';
import 'package:uni/view/login/widgets/create_link.dart';
import 'package:uni/view/login/widgets/f_login_button.dart';
import 'package:uni/view/login/widgets/inputs.dart';
import 'package:uni/view/login/widgets/remember_me_checkbox.dart';
import 'package:uni/view/login/widgets/terms_and_conditions_button.dart';
import 'package:uni_ui/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

/// Manages the 'login section' view.
class LoginPageViewState extends State<LoginPageView>
    with WidgetsBindingObserver {
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
  bool _intercepting = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_intercepting) {
      setState(() => _loggingIn = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _login() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    if (!_loggingIn && _formKey.currentState!.validate()) {
      final user = usernameController.text.trim();
      final pass = passwordController.text.trim();

      try {
        setState(() {
          _loggingIn = true;
        });

        final initiator =
            CredentialsSessionInitiator(username: user, password: pass);
        await sessionProvider.login(
          initiator,
          persistentSession: _keepSignedIn,
        );

        usernameController.clear();
        passwordController.clear();

        if (mounted) {
          await Navigator.pushReplacementNamed(
            context,
            '/${NavigationItem.navPersonalArea.route}',
          );
          setState(() {
            _loggingIn = false;
          });
        }
      } on AuthenticationException catch (err, st) {
        setState(() {
          _loggingIn = false;
        });

        switch (err.type) {
          case AuthenticationExceptionType.expiredCredentials:
            _updatePasswordDialog();
          case AuthenticationExceptionType.internetError:
            if (mounted) {
              unawaited(
                ToastMessage.warning(
                  context,
                  S.of(context).internet_status_exception,
                ),
              );
            }
          case AuthenticationExceptionType.wrongCredentials:
            if (mounted) {
              unawaited(
                ToastMessage.error(
                  context,
                  S.of(context).wrong_credentials_exception,
                ),
              );
            }
          default:
            Logger().e(err, stackTrace: st);
            unawaited(Sentry.captureException(err, stackTrace: st));
            if (mounted) {
              unawaited(
                ToastMessage.error(context, S.of(context).failed_login),
              );
            }
            break;
        }
      }
      // Handles other unexpected exceptions
      catch (err, st) {
        setState(() {
          _loggingIn = false;
        });
        Logger().e(err, stackTrace: st);
        unawaited(Sentry.captureException(err, stackTrace: st));
        if (mounted) {
          unawaited(ToastMessage.error(context, S.of(context).failed_login));
        }
      }
    }
  }

  Future<void> _falogin() async {
    final stateProviders = StateProviders.fromContext(context);
    final sessionProvider = stateProviders.sessionProvider;

    try {
      setState(() {
        _loggingIn = true;
      });

      final appLinks = UniAppLinks();

      await sessionProvider.login(
        FederatedSessionInitiator(
          clientId: clientId,
          realm: Uri.parse(realm),
          performAuthentication: (flow) async {
            final data = await appLinks.login.intercept((redirectUri) async {
              flow.redirectUri = redirectUri;
              await launchUrl(flow.authenticationUri);
            });

            await closeInAppWebView();

            return data;
          },
        ),
        persistentSession: _keepSignedIn,
      );

      setState(() {
        _intercepting = true;
        _loggingIn = true;
      });

      if (mounted) {
        await Navigator.pushReplacementNamed(
          context,
          '/${NavigationItem.navPersonalArea.route}',
        );
      }

      setState(() {
        _loggingIn = true;
        _intercepting = false;
      });
    } catch (err, st) {
      await Sentry.captureException(err, stackTrace: st);
      await closeInAppWebView();
      setState(() {
        _loggingIn = false;
      });
      if (mounted) {
        Logger().e(S.of(context).failed_to_authenticate);
        unawaited(
            ToastMessage.error(context, S.of(context).failed_to_authenticate));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme.copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF280709),
          body: BackButtonExitWrapper(
            child: Stack(
              children: [
                Center(
                  child: Align(
                    alignment: const Alignment(0, -0.4),
                    child: Hero(
                      tag: 'logo',
                      flightShuttleBuilder: (
                        flightContext,
                        animation,
                        flightDirection,
                        fromHeroContext,
                        toHeroContext,
                      ) {
                        return ScaleTransition(
                          scale: animation.drive(
                            Tween<double>(begin: 1, end: 1).chain(
                              CurveTween(curve: Curves.easeInOut),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/logo_dark.svg',
                            width: 90,
                            height: 90,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFF5F3),
                              BlendMode.srcIn,
                            ),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/images/logo_dark.svg',
                        width: 90,
                        height: 90,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFF5F3),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(-0.95, -1),
                      colors: [
                        Color(0x705F171D),
                        Color(0x02511515),
                      ],
                      stops: [0, 1],
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.1, 0.95),
                      radius: 0.3,
                      colors: [
                        Color(0x705F171D),
                        Color(0x02511515),
                      ],
                      stops: [0, 1],
                    ),
                  ),
                ),
                if (_loggingIn)
                  const Align(
                    alignment: Alignment(0, 0.35),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                if (!_loggingIn)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 14,
                    ),
                    child: Align(
                      alignment: const Alignment(0, 0.35),
                      child: FLoginButton(onPressed: _falogin),
                    ),
                  ),
                Align(
                  alignment: const Alignment(0, 0.51),
                  child: RememberMeCheckBox(
                    keepSignedIn: _keepSignedIn,
                    onToggle: () {
                      setState(() {
                        _keepSignedIn = !_keepSignedIn;
                      });
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 37),
                    theme: lightTheme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.58),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: LinkWidget(
                      textStart: S.of(context).try_different_login,
                      textEnd: S.of(context).login_with_credentials,
                      recognizer: TapGestureRecognizer()
                        ..onTap = _showAlternativeLogin,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment(0, 0.88),
                  child: TermsAndConditionsButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// I don't think this is being used anywhere, should I delete to clean up?
  /// Creates a widget for the user login depending on the status of his login.
  /*Widget createStatusWidget(BuildContext context) {
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
  }*/

  Future<void> _showAlternativeLogin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return AlertDialog(
          title: Text(
            S.of(context).login_with_credentials,
            style: lightTheme.textTheme.headlineLarge?.copyWith(
              color: const Color(0xFF280709),
            ),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          backgroundColor: const Color(0xFFFFF5F3),
          actionsAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 10),
                      createPasswordInput(
                        context,
                        passwordController,
                        passwordFocus,
                        () {
                          setState(() {
                            _obscurePasswordInput = !_obscurePasswordInput;
                          });
                        },
                        _login,
                        obscurePasswordInput: _obscurePasswordInput,
                      ),
                      const SizedBox(height: 15),
                      RememberMeCheckBox(
                        keepSignedIn: _keepSignedIn,
                        onToggle: () {
                          setState(() {
                            _keepSignedIn = !_keepSignedIn;
                          });
                        },
                        textColor: const Color(0xFF280709),
                        padding: EdgeInsets.zero,
                        theme: lightTheme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF280709),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C0A0E),
                foregroundColor: const Color(0xFFFFF5F3),
                side: const BorderSide(color: Color(0xFF56272B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).cancel),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C0A0E),
                foregroundColor: const Color(0xFFFFF5F3),
                side: const BorderSide(color: Color(0xFF56272B)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _login();
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                }
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
