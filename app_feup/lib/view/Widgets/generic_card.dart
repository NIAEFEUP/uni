import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uni/model/entities/time_utilities.dart';

abstract class GenericCard extends StatefulWidget {
  GenericCard({Key key})
      : editingMode = false,
        onDelete = null,
        super(key: key);

  GenericCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : editingMode = editingMode,
        onDelete = onDelete,
        super(key: key);

  final bool editingMode;
  final Function onDelete;

  @override
  State<StatefulWidget> createState() {
    return  GenericCardState();
  }

  Widget buildCardContent(BuildContext context);
  String getTitle();
  onClick(BuildContext context);

  Text getInfoText(String text, BuildContext context) {
    return Text(text == null ? 'N/A' : text,
        textAlign: TextAlign.end, style: Theme.of(context).textTheme.display2);
  }

  showLastRefreshedTime(time, context) {
    if (time == null) return Text('N/A');
    final t = DateTime.parse(time);
    return Container(
        child: Text(
            'última atualização às ' +
                t.toTimeString(),
            style: Theme.of(context).textTheme.display3),
        alignment: Alignment.center);
  }
}

class GenericCardState extends State<GenericCard> {
  final double borderRadius = 10.0;
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(context),
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            shape:  RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(this.borderRadius)),
            child:  Container(
              decoration: BoxDecoration(
                  boxShadow: [
                     BoxShadow(
                        color: Color.fromARGB(0x1c, 0, 0, 0),
                        blurRadius: 7.0,
                        offset: Offset(0.0, 1.0))
                  ],
                  color: Theme.of(context).accentColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius))),
              child:  ConstrainedBox(
                constraints:  BoxConstraints(
                  minHeight: 60.0,
                ),
                child:  Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(this.borderRadius))),
                  width: (double.infinity),
                  child:  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                       Row(
                        children: [
                          Flexible(
                              child: Container(
                            child: Text(widget.getTitle(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .apply(
                                        fontSizeDelta: -53,
                                        fontWeightDelta: -3)),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 16),
                            margin: EdgeInsets.only(top: 15, bottom: 11),
                          )),
                          this.getDeleteIcon(context)
                        ].where((e) => e != null).toList(),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: this.padding,
                            right: this.padding,
                            bottom: this.padding,
                            top: 4.0),
                        child: widget.buildCardContent(context),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget getDeleteIcon(context) {
    return (widget.editingMode != null && widget.editingMode)
        ? IconButton(
            iconSize: 22.0,
            icon: Icon(Icons.delete),
            tooltip: 'Remover',
            color: Theme.of(context).textTheme.title.color,
            onPressed: widget.onDelete,
          )
        : null;
  }
}
