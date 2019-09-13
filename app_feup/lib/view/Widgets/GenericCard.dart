import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenericCard extends StatelessWidget {
  GenericCard({Key key, @required this.title, this.child, this.func})
      : super(key: key);

  final String title;
  final Widget child;
  final double borderRadius = 10.0;
  final VoidCallback func;
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (func != null) func();
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Color.fromARGB(0, 0, 0, 0),
          elevation: 0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(this.borderRadius)),
          child: new Container(
            decoration: BoxDecoration(
                boxShadow: [new BoxShadow(color: Color.fromARGB(0x0c, 0, 0, 0), blurRadius: 7.0, offset: Offset(0.0, 1.0))],
                color: Theme.of(context).accentColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(this.borderRadius))),
                child: new ConstrainedBox(
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
                        new Container(
                          child: Text(title, style: Theme.of(context).textTheme.headline.apply(fontSizeDelta: -53, fontWeightDelta: -3)),
                          height: 26,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16),
                          margin: EdgeInsets.only(top: 11, bottom: 11),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: this.padding, right: this.padding, bottom: this.padding, top: 4.0),
                          child: this.child,
                        )
                      ],
                  ),
                ),
            ),
          ),
        ));
  }
}
