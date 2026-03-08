import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    this.image,
    required this.openLink,
  });

  final String title;
  final String description;
  final Widget? image;
  final void Function()? openLink;

  @override
  Widget build(BuildContext context) {
    return GenericCard(
      onClick: openLink,
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(0x25),
      blurRadius: 2,
      tooltip: title,
      padding: const EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(color: CardTheme.of(context).color),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (image != null) SizedBox(height: 90, child: image),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
