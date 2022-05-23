import 'package:flutter/material.dart';
import 'package:uni/view/Pages/bus_stop_next_arrivals_page.dart';

class StopsPage extends StatefulWidget {
  const StopsPage({Key key}) : super(key: key);

  @override
  _StopsPageState createState() => _StopsPageState();
}

class _StopsPageState extends State<StopsPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BusStopNextArrivalsPage();
  }
}
