
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Widgets/cantine_row.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'date_rectangle.dart';
import 'generic_card.dart';

class CantineCard extends GenericCard {
  CantineCard({Key key}) : super(key: key);

  CantineCard.fromEditingInformation(
    Key key, bool editingMode, Function onDelete) 
  : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  String getTitle() => 'Cantinas';

  @override
  onClick(BuildContext context) =>
      null;

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<String, RequestStatus>> (
        converter: (store) => Tuple2('Cantina da FEUP - Almoço',
         RequestStatus.none),
        builder: (context, cantine) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: cantine.item2,
              contentGenerator: generateCantines,
              content: cantine.item1,
              contentChecker:
                  cantine.item1 != null && cantine.item1.isNotEmpty,
              onNullContent: Center(
                  child: Text('Não existem cantinas para apresentar',
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
      });
  }

  Widget generateCantines(cantines, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        createRowFromCantine(context, cantines)
      ],
    );
  }

  Widget createRowFromCantine(context, String cantine) { // TODO: Cantine class
    return Column(children: [
      DateRectangle(date: 'Segunda' + ', ' + '08' + ' de ' + 'Janeiro'),
       // cantine.nextSchoolDay
      Container(
        child: Center(
          child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
              border: Border(bottom: BorderSide(
                width: 0.1, color: Theme.of(context).accentColor))),
              child: Text(cantine)
          )
        ),
      ),
      Container(
        child: RowContainer(
          color: Theme.of(context).backgroundColor,
          child:  CantineRow(
            local: cantine,
            meatMenu: 'Tripas à moda do Porto',
            fishMenu: 'Bacalhau à Brás',
            vegetarianMenu: 'Risoto de shitake',
            dietMenu: 'Perna de frango cozida com batata',
         )
        ),
      ),
    ]);
  }
}

