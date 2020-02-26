import 'package:uni/view/Pages/BusStopNextArrivalsPage.dart';
import 'package:flutter/material.dart';

class StopsPage extends StatefulWidget{

  const StopsPage({Key key}) : super(key: key);

  @override
  _StopsPageState createState() => new _StopsPageState();
}

class _StopsPageState extends State<StopsPage> with SingleTickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return new BusStopNextArrivalsPage();
  }
}