import 'package:flutter/cupertino.dart';
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
        return MarkdownBody(
          styleSheet: MarkdownStyleSheet(),
          shrinkWrap: false,
          data: termsAndConditionsSaved!,
          onTapLink: (text, url, title) async {
            await launchUrlWithToast(context, url!);
          },
        );
      },
    );
  }
}
