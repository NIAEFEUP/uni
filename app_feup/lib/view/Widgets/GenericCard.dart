import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class GenericCard extends StatefulWidget {

  GenericCard({Key key})
      : super(key: key);

  GenericCardState state = new GenericCardState();

  @override
  State<StatefulWidget> createState() => state;


  Widget buildCardContent(BuildContext context);
  String getTitle();
  onClick(BuildContext context);

  void setEditingMode(bool mode) => state.setEditingMode(mode);
  void setOnDelete(Function func) => state.setOnDelete(func);

  Text getInfoText(String text, BuildContext context) {
    return Text(text,
        textAlign: TextAlign.end,
        style: Theme.of(context).textTheme.display2
    );
  }
}


class GenericCardState extends State<GenericCard> {

  bool editingMode;
  Function onDelete;

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
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(this.borderRadius)),
          child: new Container(
            decoration: BoxDecoration(
                boxShadow: [new BoxShadow(color: Color.fromARGB(0x0c, 0, 0, 0), blurRadius: 7.0)],
                color: Theme.of(context).accentColor,
                borderRadius:
                BorderRadius.all(Radius.circular(this.borderRadius))),
            child:
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
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                          children:[
                            new Container(
                              child: Text(widget.getTitle(), style: Theme.of(context).textTheme.headline.apply(fontSizeDelta: -53, fontWeightDelta: -3)),
                              height: 26,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16),
                              margin: EdgeInsets.only(top: 11, bottom: 11),
                            ),
                            this.getDeleteIcon(context)
                          ].where((e) => e != null).toList(),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: this.padding, right: this.padding, bottom: this.padding, top: 4.0),
                          child: widget.buildCardContent(context),
                        )
                      ],
                  ),
                ),
            ),
        ))
    );
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