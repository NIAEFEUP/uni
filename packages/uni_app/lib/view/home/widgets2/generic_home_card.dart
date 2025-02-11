import 'package:flutter/material.dart';

abstract class GenericHomecard extends StatelessWidget {
  const GenericHomecard({
    required this.title,
    this.externalInfo = false,
    super.key,
  });

  final String title;
  final bool externalInfo;

  Widget buildCardContent(BuildContext context);

  void onClick(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                if (externalInfo)
                  TextButton(
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.all(
                        Theme.of(context).textTheme.headlineSmall,
                      ),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () => onClick(context),
                    child: const Text('Ver mais'),
                  ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: buildCardContent(context),
            ),
          ],
        ),
      ),
    );
  }
}
