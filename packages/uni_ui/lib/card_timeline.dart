import 'package:flutter/material.dart';
import 'package:uni_ui/generic_card.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CardTimeline extends StatelessWidget {
  const CardTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [Text('10h30'), Text('12h30')],
      ),
      Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 4.0,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
            height: 50,
            width: 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).primaryColor))
      ]),
      Expanded(
          child: GenericCard(
        key: key,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'LCOM',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontSize,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .fontWeight,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 8), //TODO: Create a custom Gap()?
                      Badge(
                        label: Text('MT'),
                        backgroundColor: Colors.greenAccent,
                        textColor: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                  Text(
                    'Laboratório de Computadores',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.titleLarge!.fontWeight,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
            Column(
              children: [
                PhosphorIcon(
                  PhosphorIcons.mapPin(PhosphorIconsStyle.duotone),
                  color: Theme.of(context).iconTheme.color,
                  size: 35,
                ),
                Text('B315',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
              ],
            )
          ],
        ),
      ))
    ]);
  }
}
