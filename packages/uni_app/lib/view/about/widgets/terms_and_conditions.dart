import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uni/controller/fetchers/core/terms_and_conditions_fetcher.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    String? termsAndConditionsSaved = S.of(context).loading_terms;
    final termsAndConditionsFuture = fetchTermsAndConditions(
      Localizations.localeOf(context).languageCode,
    );
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
                  p: Theme.of(context).textTheme.bodyMedium,
                  h1: Theme.of(context).textTheme.displayLarge,
                  h1Align: WrapAlignment.center,
                  h2: Theme.of(context).textTheme.displayMedium,
                  h2Align: WrapAlignment.center,
                  h3: Theme.of(context).textTheme.titleLarge,
                  h1Padding: const EdgeInsets.only(top: 24),
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
