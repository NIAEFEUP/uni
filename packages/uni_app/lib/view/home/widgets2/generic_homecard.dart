import 'package:flutter/material.dart';

abstract class GenericHomecard extends StatelessWidget {
  const GenericHomecard({required this.title, super.key});

  final String title;

  Widget buildCardContent(BuildContext context);

  void onClick(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick,
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
                title,
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
