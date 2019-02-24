import 'package:app_feup/view/widgets/NavigationDrawer.dart';
import 'package:flutter/material.dart';

class SchedulePageView extends StatelessWidget {

  SchedulePageView(
      {Key key,
        @required this.daysOfTheWeek})
      : super(key: key);

  final daysOfTheWeek;

  @override
  Widget build(BuildContext context) {

    final MediaQueryData queryData = MediaQuery.of(context);

    return new Scaffold(
        appBar: new AppBar(
            title: new Text("App FEUP"),
        ),
        drawer: new NavigationDrawer(),
      body: new DefaultTabController(
        length: 5,
        child: new Column(
          children: <Widget>[
            new Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
              constraints: BoxConstraints(maxHeight: 150.0),
              child: new Material(
                color: Colors.white,
                child: new TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.grey,
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.grey,
                  labelPadding: EdgeInsets.all(0.0),
                  tabs: _createTabs(queryData),
                ),
              ),
            ),
            new Expanded(
              child: new TabBarView(
                children: [
                  new Tab(text: "Segunda"),
                  new Tab(text: 'Terça'),
                  new Tab(text: 'Quarta'),
                  new Tab(text: 'Quinta'),
                  new Tab(text: 'Sexta')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createTabs(queryData) {
    List<Widget> tabs = [];
    for( var i = 0; i < daysOfTheWeek.length; i++) {
      tabs.add(
          new Container(
            width:  queryData.size.width * 1/3,
            child: new Tab(text: daysOfTheWeek[i]),
          )
      );
    }
    return tabs;
  }
}