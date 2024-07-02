import 'package:flutter/material.dart';
import 'package:uni/controller/networking/url_launcher.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    required this.title,
    required this.link,
    super.key,
  });
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 14, left: 20),
              child: InkWell(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(decoration: TextDecoration.underline),
                ),
                onTap: () => launchUrlWithToast(context, link),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
