import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  GeneralCard({Key key,
    @required this.title,
              this.child}) : super(key: key);

  final String title;
  final Widget child;
  final double borderRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
          constraints: new BoxConstraints(
          minHeight: 150.0,
      ),
      child: new Card(
        margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
        color: Color.fromARGB(0, 0, 0, 0),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(this.borderRadius)),
        child: new Container(
          height: 4*this.borderRadius,
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              border: Border.all(color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
              borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
          child:
          new Column(
            children: <Widget>[
              new Container(
                child: Text(title,
                    style: Theme.of(context).textTheme.title),
                height: 26,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              ),
              new Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
                  width: (double.infinity),
                  padding: EdgeInsets.all(15.0),
                  child: this.child,
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
