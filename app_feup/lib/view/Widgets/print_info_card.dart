import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'generic_card.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/view/Widgets/row_container.dart';
import 'package:uni/view/Widgets/create_print_mb_dialog.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:tuple/tuple.dart';

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
            columnWidths: {
              1: FractionColumnWidth(0.4),
              2: FractionColumnWidth(.1)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 20.0, bottom: 20.0, left: 20.0),
                  child: Text('Valor disponível: ',
                      style: Theme.of(context).textTheme.subtitle2),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  child: StoreConnector<AppState, String>(
                      converter: (store) => store.state.content['printBalance'],
                      builder: (context, printBalance) => Text(
                          printBalance ?? 'N/A',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headline6)),
                ),
                Container(
                    margin: EdgeInsets.only(right: 5.0),
                    height: 30,
                    child: addMoneyButton(context))
              ])
            ]),
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 0.0, left: 20.0, right: 20.0),
            child: Text('Movimentos Recentes: ',
                style: Theme.of(context).textTheme.subtitle2)),
        Container(
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: StoreConnector<AppState, Tuple2>(
                converter: (store) => Tuple2(
                    store.state.content['printMovements'],
                    store.state.content['printStatus']),
                builder: (context, printMovements) {
                  return RequestDependentWidgetBuilder(
                      context: context,
                      status: printMovements.item2,
                      contentGenerator: printBalanceMovementsWidget,
                      content: printMovements.item1,
                      contentChecker: printMovements.item1 != null &&
                          printMovements.item1.isNotEmpty,
                      onNullContent: Center(
                          child: getEmptyContainer(
                              'Não existem movimentos recentes', context)));
                })),
        StoreConnector<AppState, String>(
            converter: (store) => store.state.content['printRefreshTime'],
            builder: (context, printRefreshTime) =>
                showLastRefreshedTime(printRefreshTime, context))
      ],
    );
  }

  /// Returns a widget with all the print balance movements.
  Widget printBalanceMovementsWidget(movements, context) {
    if (movements.length <= 0) {
      return getEmptyContainer('Não existem movimentos recentes', context);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: this.printBalanceMovements(context, movements),
    );
  }

  /// Returns a list of widgets with movements to be displayed in the print card
  List<Widget> printBalanceMovements(context, movements) {
    final List<Widget> rows = movements.map<Widget>((movement) {
      return this.balanceMovement(context, movement);
    }).toList();

    return rows.length <= 3 ? rows : rows.sublist(0, 3);
  }

  bool isNegative(movement) => movement['value'][0] != '-';

  // Individual movement row
  Widget balanceMovement(context, movement) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: RowContainer(
        color: Theme.of(context).backgroundColor,
        child: Container(
          padding: EdgeInsets.all(11),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(DateTime.parse(movement['datetime'])
                    .toFormattedDateString()),
                isNegative(movement)
                  ? Text('+' + movement['value'],
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .apply(color: Colors.green))
                  : Text(movement['value'],
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .apply(color: Theme.of(context).accentColor))
              ]),
        ),
      ),

  Widget addMoneyButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => addMoneyDialog(context),
      child: Center(child: Icon(Icons.add)),
    );
  }

  @override
  String getTitle() => 'Impressões';

  @override
  onClick(BuildContext context) {}
}
