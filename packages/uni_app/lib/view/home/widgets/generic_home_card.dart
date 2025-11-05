import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_ui/theme.dart';

abstract class GenericHomecard extends ConsumerWidget {
  const GenericHomecard({super.key, this.titlePadding, this.bodyPadding});

  final EdgeInsetsGeometry? titlePadding;

  final EdgeInsetsGeometry? bodyPadding;

  String getTitle(BuildContext context) => '';

  Widget buildCardContent(BuildContext context);

  void onCardClick(BuildContext context);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleWidget = Text(
      getTitle(context),
      style: Theme.of(context).headlineLarge,
    );

    return GestureDetector(
      onTap: () => onCardClick(context),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (titlePadding != null)
                Padding(padding: titlePadding!, child: titleWidget)
              else
                titleWidget,
              Container(
                margin: const EdgeInsets.only(top: 10),
                child:
                    bodyPadding != null
                        ? Padding(
                          padding: bodyPadding!,
                          child: buildCardContent(context),
                        )
                        : buildCardContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
