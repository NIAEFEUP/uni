import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    _refreshSession();
  }

  Future<void> _refreshSession() async {
    final refreshedSession = await ref
        .read(sessionProvider.notifier)
        .refreshSilently();
    if (mounted) {
      setState(() {
        session = refreshedSession;
        if (session == null) {
          isLoading = false;
        }
      });
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
                    final cookieManager = CookieManager.instance();
                    const baseUrl = 'https://sigarra.up.pt';

                    for (final cookie in session!.cookies) {
                      await cookieManager.setCookie(
                        url: WebUri(baseUrl),
                        name: cookie.name,
                        value: cookie.value,
                        domain: cookie.domain ?? 'sigarra.up.pt',
                        path: cookie.path ?? '/',
                        isSecure: cookie.secure,
                        isHttpOnly: cookie.httpOnly,
                      );
                    }
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                        final url =
                            navigationAction.request.url?.toString() ?? '';

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
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              if (session == null && !isLoading)
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: Text(
                      S.of(context).session_expired,
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
