import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

class PaymentWebView extends ConsumerStatefulWidget {
  const PaymentWebView({super.key, required this.url, this.onGatewayEntered});

  final String url;
  final VoidCallback? onGatewayEntered;

  @override
  ConsumerState<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends ConsumerState<PaymentWebView> {
  bool isLoading = true;
  Session? session;
  bool _hasEnteredGateway = false;
  bool _hasRetriedAfterSessionExpiry = false;
  bool _hasError = false;
  String? _loadingMessage;
  Timer? _loadingMessageTimer;

  @override
  void initState() {
    super.initState();
    session = ref.read(sessionProvider).value;
    if (session == null) {
      isLoading = false;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && isLoading) {
          _startLoadingMessages();
        }
      });
    }
  }

  @override
  void dispose() {
    _loadingMessageTimer?.cancel();
    super.dispose();
  }

  void _startLoadingMessages() {
    if (_loadingMessageTimer != null) {
      return;
    }

    final messages = [
      S.of(context).payment_loading_fetching_user_info,
      S.of(context).payment_loading_checking_debts,
      S.of(context).payment_loading_connecting,
    ];
    var index = 0;

    setState(() => _loadingMessage = messages[index]);
    _loadingMessageTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) {
        return;
      }
      index = (index + 1) % messages.length;
      setState(() => _loadingMessage = messages[index]);
    });
  }

  void _stopLoadingMessages() {
    _loadingMessageTimer?.cancel();
    _loadingMessageTimer = null;
    if (mounted) {
      setState(() => _loadingMessage = null);
    }
  }

  void _failPayment({required bool hasError}) {
    _stopLoadingMessages();
    if (!mounted) {
      return;
    }
    setState(() {
      session = null;
      isLoading = false;
      _hasError = hasError;
    });
  }

  Future<void> _injectCookies(
    InAppWebViewController controller,
    Session session,
  ) async {
    final cookieManager = CookieManager.instance();
    const baseUrl = 'https://sigarra.up.pt';

    await Future.wait([
      for (final cookie in session.cookies)
        cookieManager.setCookie(
          url: WebUri(baseUrl),
          name: cookie.name,
          value: cookie.value,
          domain: cookie.domain ?? 'sigarra.up.pt',
          path: cookie.path ?? '/',
          isSecure: cookie.secure,
          isHttpOnly: cookie.httpOnly,
        ),
    ]);
  }

  Future<void> _handleSessionExpired(InAppWebViewController controller) async {
    if (_hasRetriedAfterSessionExpiry) {
      _failPayment(hasError: true);
      return;
    }
    _hasRetriedAfterSessionExpiry = true;

    try {
      final refreshedSession = await ref
          .read(sessionProvider.notifier)
          .refreshSilently();

      if (refreshedSession == null || identical(refreshedSession, session)) {
        _failPayment(hasError: refreshedSession != null);
        return;
      }

      session = refreshedSession;
      await _injectCookies(controller, refreshedSession);
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri(widget.url)),
      );
    } catch (err, st) {
      Logger().e(
        'Failed to refresh session while retrying a payment',
        error: err,
        stackTrace: st,
      );
      _failPayment(hasError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              if (session != null)
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                  initialSettings: InAppWebViewSettings(
                    useShouldOverrideUrlLoading: true,
                  ),
                  gestureRecognizers: const {
                    Factory<VerticalDragGestureRecognizer>(
                      VerticalDragGestureRecognizer.new,
                    ),
                  },
                  onWebViewCreated: (controller) async {
                    await _injectCookies(controller, session!);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                        final url =
                            navigationAction.request.url?.toString() ?? '';

                        if (url.contains('vld_validacao.validacao')) {
                          await _handleSessionExpired(controller);
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (url.contains('/payment-gateway/')) {
                          if (!_hasEnteredGateway) {
                            _hasEnteredGateway = true;

                            await Future.microtask(() {
                              widget.onGatewayEntered?.call();
                            });
                          }

                          return NavigationActionPolicy.ALLOW;
                        }

                        if (_hasEnteredGateway && url.contains('sigarra.up')) {
                          if (mounted) {
                            Navigator.of(context).pop(true);
                          }

                          return NavigationActionPolicy.CANCEL;
                        }

                        if (url.contains('sigarra.up')) {
                          return NavigationActionPolicy.ALLOW;
                        }

                        return NavigationActionPolicy.CANCEL;
                      },
                  onLoadStop: (controller, url) async {
                    final urlString = url?.toString() ?? '';

                    if (urlString.contains('https://www.up')) {
                      _stopLoadingMessages();
                      setState(() {
                        isLoading = false;
                      });
                    }

                    await controller.evaluateJavascript(
                      source: """
                      const btn = document.getElementById('botao-mb');
                      if (btn) btn.click();
                    """,
                    );
                  },
                ),
              if (isLoading)
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        if (_loadingMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _loadingMessage!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              if (session == null && !isLoading)
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Text(
                      _hasError
                          ? S.of(context).payment_unexpected_error
                          : S.of(context).session_expired,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
