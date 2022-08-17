import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {
  final String title;
  final String link;
  const LinkButton({
    Key? key,
    required this.title,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
                margin: const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                child: InkWell(
                  child: Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(decoration: TextDecoration.underline)),
                  onTap: () => launchUrl(Uri.parse(link)),
                ))
          ]),
        ]);
  }
}
