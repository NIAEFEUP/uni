import 'package:flutter/material.dart';
import '../../view/Theme.dart';

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
                border: Border.all(width: 0.5, color: greyBorder),
                borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
            child:
            new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  child: Text(title,
                      style: TextStyle(fontWeight: FontWeight.w500)),
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
                        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
                    width: (double.infinity),
                    child: this.child,
                  ),
                ),
              ],
            ),
      ),
    );

  }
}
