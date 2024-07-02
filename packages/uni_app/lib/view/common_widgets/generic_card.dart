import 'package:flutter/material.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/view/common_widgets/widgets/delete_icon.dart';
import 'package:uni/view/common_widgets/widgets/move_icon.dart';

/// App default card
abstract class GenericCard extends StatelessWidget {
  GenericCard({Key? key})
      : this.customStyle(key: key, editingMode: false, onDelete: () {});

  const GenericCard.fromEditingInformation(
    Key key, {
    required bool editingMode,
    void Function()? onDelete,
  }) : this.customStyle(
          key: key,
          editingMode: editingMode,
          onDelete: onDelete,
        );

  const GenericCard.customStyle({
    required this.editingMode,
    required this.onDelete,
    this.cardAction = const SizedBox.shrink(),
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.hasSmallTitle = false,
  });

  static const double borderRadius = 10;
  static const double padding = 12;

  final EdgeInsetsGeometry margin;
  final Widget cardAction;
  final bool hasSmallTitle;
  final bool editingMode;
  final void Function()? onDelete;

  Widget buildCardContent(BuildContext context);

  String getTitle(BuildContext context);

  void onClick(BuildContext context);

  void onRefresh(BuildContext context);

  Text getInfoText(String text, BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  StatelessWidget showLastRefreshedTime(String? time, BuildContext context) {
    if (time == null) {
      return const Text('N/A');
    }

    final parsedTime = DateTime.tryParse(time);
    if (parsedTime == null) {
      return const Text('N/A');
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        'última atualização às ${parsedTime.toTimeHourMinString()}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!editingMode) {
          onClick(context);
        }
      },
      child: Card(
        margin: margin,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(0x1c, 0, 0, 0),
                blurRadius: 7,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 60,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(borderRadius)),
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Text(
                            getTitle(context),
                            style: (hasSmallTitle
                                    ? Theme.of(context).textTheme.titleLarge!
                                    : Theme.of(context)
                                        .textTheme
                                        .headlineSmall!)
                                .copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      cardAction,
                      if (editingMode)
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 8),
                          child: const MoveIcon(),
                        ),
                      if (editingMode) DeleteIcon(onDelete: onDelete),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      left: padding,
                      right: padding,
                      bottom: padding,
                    ),
                    child: buildCardContent(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
