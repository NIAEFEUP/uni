import 'package:app_feup/view/widgets/NavigationDrawer.dart';
import 'package:flutter/material.dart';

class SchedulePageView extends StatelessWidget {

  SchedulePageView(
      {Key key,
        @required this.tabController,
        @required this.daysOfTheWeek})
      : super(key: key);

  final List<String> daysOfTheWeek;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {

    final MediaQueryData queryData = MediaQuery.of(context);

    return new Scaffold(
        appBar: new AppBar(
            title: new Text("App FEUP"),
        ),
        drawer: new NavigationDrawer(),
        body:  new Column(
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
                  controller: tabController,
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.grey,
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.grey,
                  labelPadding: EdgeInsets.all(0.0),
                  tabs: createTabs(queryData),
                ),
              ),
            ),
            new Expanded(
              child: new TabBarView(
                controller: tabController,
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
      );
  }

  List<Widget> createTabs(queryData) {
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