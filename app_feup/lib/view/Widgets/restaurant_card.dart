import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Widgets/restaurant_row.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'date_rectangle.dart';
import 'generic_card.dart';

class RestaurantCard extends GenericCard {
  RestaurantCard({Key key}) : super(key: key);

  RestaurantCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Cantinas';

  @override
  onClick(BuildContext context) => null;

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<String, RequestStatus>>(
        converter: (store) => Tuple2(
            '', // TODO: Issue #390
            RequestStatus.none),
        builder: (context, canteen) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: canteen.item2,
              contentGenerator: generateRestaurant,
              content: canteen.item1,
              contentChecker: canteen.item1 != null && canteen.item1.isNotEmpty,
              onNullContent: Center(
                  child: Text('Não existem cantinas para apresentar',
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateRestaurant(canteens, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [createRowFromRestaurant(context, canteens)],
    );
  }

  Widget createRowFromRestaurant(context, String canteen) {
    // TODO: Issue #390
    return Column(children: [
      DateRectangle(date: ''), // TODO: Issue #390
      // cantine.nextSchoolDay
      Container(
        child: Center(
            child:
                Container(padding: EdgeInsets.all(12.0), child: Text(canteen))),
      ),
      Card(
        elevation: 1,
        child: RowContainer(
            color: Color.fromARGB(0, 0, 0, 0),
            child: RestaurantRow(
              local: canteen,
              meatMenu: '', // TODO: Issue #390
              fishMenu: '',
              vegetarianMenu: '',
              dietMenu: '',
            )),
      ),
    ]);
  }
}
