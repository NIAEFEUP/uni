import 'package:flutter/material.dart';
import 'package:uni_ui/cards/generic_card.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.openLink,
  });

  final String title;
  final String description;
  final String image;
  final void Function()? openLink;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: GenericCard(
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
              Image.network(image, height: 90, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: Column(
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
      ),
    );
  }
}
