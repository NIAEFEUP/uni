import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uni/controller/fetchers/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    String? termsAndConditionsSaved = S.of(context).loading_terms;
    final termsAndConditionsFuture = fetchTermsAndConditions();
    return FutureBuilder(
      future: termsAndConditionsFuture,
      builder: (context, termsAndConditions) {
        if (termsAndConditions.connectionState == ConnectionState.done &&
            termsAndConditions.hasData) {
          termsAndConditionsSaved = termsAndConditions.data;
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: MarkdownBody(
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  h1: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  h1Align: WrapAlignment.center,
                  h2: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  h2Align: WrapAlignment.center,
                  h3: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  h2Padding: const EdgeInsets.only(top: 16, bottom: 12),
                  h3Padding: const EdgeInsets.only(top: 20, bottom: 8),
                ),
            data: termsAndConditionsSaved!,
            onTapLink: (text, url, title) async {
              await launchUrlWithToast(context, url!);
            },
          ),
        );
      },
    );
  }
}
