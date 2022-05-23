import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'generic_card.dart';

class PrintInfoCard extends GenericCard {
  PrintInfoCard({Key key}) : super(key: key);

  PrintInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Table(
            columnWidths: {1: FractionColumnWidth(.4)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 20.0),
                  child: Text('Valor disponível: ',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(fontSizeDelta: -4)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, right: 30.0),
                  child: StoreConnector<AppState, String>(
                      converter: (store) => store.state.content['printBalance'],
                      builder: (context, printBalance) =>
                          getInfoText(printBalance, context)),
                ),
              ])
            ]),
        StoreConnector<AppState, String>(
            converter: (store) => store.state.content['printRefreshTime'],
            builder: (context, printRefreshTime) =>
                showLastRefreshedTime(printRefreshTime, context))
      ],
    );
  }

  @override
  String getTitle() => 'Impressões';

  @override
  onClick(BuildContext context) {}
}
