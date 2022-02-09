import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/locations_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import 'entities/location_group.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key key}) : super(key: key);

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController scrollViewController;




  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<LocationGroup>>(
      converter: (store) => store.state.content['locationGroups'],
      builder: (context, data) {
        print(data);
        return LocationsPageView(data);
      },
    );
  }
}
