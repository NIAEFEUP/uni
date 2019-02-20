import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  GenericCard({Key key,
    @required this.title,
              this.child}) : super(key: key);

  final String title;
  final Widget child;
  final double borderRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    return new Card(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
        color: Color.fromARGB(0, 0, 0, 0),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(this.borderRadius)),

        child: new Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                border: Border.all(width: 0.5, color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
                borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
            child:
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  child: Text(title,
                      style: Theme.of(context).textTheme.title),
                  height: 26,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                ),
                new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 100.0,
                  ),
                  child: new Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
                    width: (double.infinity),
                    padding: EdgeInsets.only(left: 0, right: 0, top: 8.0, bottom: 10.0),
                    child: this.child,
                  ),
                ),
              ],
            ),
      ),
    );

  }
}
