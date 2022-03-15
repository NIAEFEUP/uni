import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              Container(
                  margin:
                      const EdgeInsets.only(top: 0, bottom: 14.0, left: 20.0),
                  child: InkWell(
                    child: Text('Impressão',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(decoration: TextDecoration.underline)),
                    onTap: () => launch('https://webprint.up.pt/wprint/'),
                  ))
            ]),
          ]),
    ]);
  }
}
