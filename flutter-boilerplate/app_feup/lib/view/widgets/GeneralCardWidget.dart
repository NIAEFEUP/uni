import 'package:flutter/material.dart';

class GeneralCard extends StatelessWidget {
  GeneralCard({Key key,
    @required this.title,
              this.widget}) : super(key: key);

  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
      color: Color.fromARGB(0, 0, 0, 0),
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      child: new Container(
        height: 250,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 235, 235, 235),
            border: Border.all(color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child:
        new Column(
          children: <Widget>[
            new Container(
              child: Text(title,
                  style: TextStyle(color: Color.fromARGB(255, 0x8C, 0x2D, 0x19))),
              height: 30,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(38, 0, 0, 0),
            ),
            new Expanded(
              child: new Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border(top: BorderSide(color: Color.fromARGB(64, 0x46, 0x46, 0x46))),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                width: (double.infinity),
                child: this.widget,
              ),
            )
          ],
        ),
      ),
    );

  }
}
