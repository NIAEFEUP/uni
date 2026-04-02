import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uni/session/flows/base/session.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({super.key, required this.url, required this.session});

  final String url;
  final Session session;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: InAppWebViewSettings(),
                gestureRecognizers: const {
                  Factory<VerticalDragGestureRecognizer>(
                    VerticalDragGestureRecognizer.new,
                  ),
                },
                onWebViewCreated: (controller) async {
                  final cookieManager = CookieManager.instance();
                  const baseUrl = 'https://sigarra.up.pt';

                  for (final cookie in widget.session.cookies) {
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
                onLoadStop: (controller, url) async {
                  await controller.evaluateJavascript(
                    source: """
                      const btn = document.getElementById('botao-mb');
                      if (btn) btn.click();
                    """,
                  );

                  await Future<void>.delayed(
                    const Duration(milliseconds: 1500),
                  );

                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),

              if (isLoading)
                Container(
                  color: Colors.white,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
