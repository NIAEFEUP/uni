import 'package:flutter/material.dart';

abstract class GenericHomecard extends StatelessWidget {
  const GenericHomecard({
    super.key,
  });

  String getTitle(BuildContext context) => '';

  Widget buildCardContent(BuildContext context);

  void onCardClick(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCardClick(context),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                getTitle(context),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: buildCardContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
