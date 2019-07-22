import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  GenericCard({Key key, @required this.title, this.child, this.onClick, this.editingMode, this.onDelete})
      : super(key: key);

  final String title;
  final Widget child;
  final double borderRadius = 15.0;
  final VoidCallback onClick;
  final bool editingMode;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onClick != null) onClick();
        },
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
                        Text(title, style: Theme.of(context).textTheme.title),
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
                    child: this.child,
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
}
