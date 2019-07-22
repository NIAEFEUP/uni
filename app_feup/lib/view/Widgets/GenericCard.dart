import 'package:flutter/material.dart';

abstract class GenericCard extends StatefulWidget {

  GenericCard({Key key}):super(key: key);

  GenericCardState state = new GenericCardState();

  @override
  State<StatefulWidget> createState() => state;


  Widget buildCardContent(BuildContext context);
  String getTitle();
  onClick(BuildContext context);

  void setEditingMode(bool mode) => state.setEditingMode(mode);
  void setOnDelete(Function func) => state.setOnDelete(func);
}


class GenericCardState extends State<GenericCard> {

  final double borderRadius = 15.0;

  bool editingMode;
  Function onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClick(context),
        child: Card(
          margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
          color: Color.fromARGB(0, 0, 0, 0),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(this.borderRadius)),
          child: new Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                border: Border.all(
                    width: 0.5, color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
                borderRadius:
                BorderRadius.all(Radius.circular(this.borderRadius))),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.getTitle(), style: Theme.of(context).textTheme.title),
                        this.getDeleteIcon(context)
                      ].where((e) => e != null).toList()),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 4, 0, 4),
                ),
                new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 60.0,
                  ),
                  child: new Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(this.borderRadius))),
                    width: (double.infinity),
                    child: widget.buildCardContent(context)
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget getDeleteIcon(context){
    return (this.editingMode != null && this.editingMode) ?
          IconButton(
            iconSize: 22.0,
            icon: Icon(Icons.delete),
            tooltip: 'Unfavorite',
            color: Theme.of(context).textTheme.title.color,
            onPressed: this.onDelete,
      ) : null;
  }

  void setEditingMode(bool mode) => editingMode = mode;
  void setOnDelete(Function func) => onDelete = func;
}