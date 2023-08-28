import 'package:flutter/material.dart';
import 'package:uni/model/entities/time_utilities.dart';

/// App default card
abstract class GenericCard extends StatefulWidget {
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
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.hasSmallTitle = false,
  });
  final EdgeInsetsGeometry margin;
  final bool hasSmallTitle;
  final bool editingMode;
  final void Function()? onDelete;

  @override
  State<StatefulWidget> createState() {
    return GenericCardState();
  }

  Widget buildCardContent(BuildContext context);

  String getTitle();

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
}

class GenericCardState extends State<GenericCard> {
  final double borderRadius = 10;
  final double padding = 12;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.editingMode) {
          widget.onClick(context);
        }
      },
      child: Card(
        margin: widget.margin,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(0x1c, 0, 0, 0),
                blurRadius: 7,
                offset: Offset(0, 1),
              )
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
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
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
                            widget.getTitle(),
                            style: (widget.hasSmallTitle
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
                      if (widget.editingMode)
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 8),
                          child: getMoveIcon(context),
                        ),
                      if (widget.editingMode) getDeleteIcon(context)
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      bottom: padding,
                    ),
                    child: widget.buildCardContent(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDeleteIcon(BuildContext context) {
    return Flexible(
      child: Container(
        alignment: Alignment.centerRight,
        height: 32,
        child: IconButton(
          iconSize: 22,
          icon: const Icon(Icons.delete),
          tooltip: 'Remover',
          onPressed: widget.onDelete,
        ),
      ),
    );
  }

  Widget getMoveIcon(BuildContext context) {
    return Icon(
      Icons.drag_handle_rounded,
      color: Colors.grey.shade500,
      size: 22,
    );
  }
}
