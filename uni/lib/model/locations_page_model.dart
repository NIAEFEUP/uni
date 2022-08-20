import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Pages/locations_page_view.dart';
import 'package:uni/view/Pages/secondary_page_view.dart';

import 'package:uni/model/entities/location_group.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController? scrollViewController;

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
    return StoreConnector<AppState,
        Tuple2<List<LocationGroup>?, RequestStatus?>>(
      converter: (store) => Tuple2(store.state.content['locationGroups'],
          store.state.content['locationGroupsStatus']),
      builder: (context, data) {
        return LocationsPageView(locations: data.item1, status: data.item2);
      },
    );
  }
}
