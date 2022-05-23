import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatefulWidget {
  final void Function() onClick;
  final String title;
  final Widget content;

  SectionCard({Key key, this.onClick = null, this.title = null, this.content})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SectionCardState();
  }
}

class SectionCardState extends State<SectionCard> {
  final double borderRadius = 10.0;
  final double padding = 12.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(this.borderRadius)),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(0x1c, 0, 0, 0),
                    blurRadius: 7.0,
                    offset: Offset(0.0, 1.0))
              ],
              color: Theme.of(context).dividerColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(this.borderRadius))),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 60.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      BorderRadius.all(Radius.circular(this.borderRadius))),
              width: (double.infinity),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (widget.title == null)
                    SizedBox(height: 18)
                  else
                    Flexible(
                      child: Container(
                        child: Text(widget.title,
                            style: Theme.of(context).textTheme.headline1.apply(
                                fontSizeDelta: -53, fontWeightDelta: -3)),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.only(
                      left: this.padding,
                      right: this.padding,
                      bottom: this.padding,
                    ),
                    child: widget.content,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
