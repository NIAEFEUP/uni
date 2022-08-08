import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/view/Profile/widgets/create_print_mb_dialog.dart';
import 'package:uni/view/Common/generic_card.dart';

class PrintInfoCard extends GenericCard {
  PrintInfoCard({Key? key}) : super(key: key);

  const PrintInfoCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  @override
  Widget buildCardContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Table(
            columnWidths: const {
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
                  child: StoreConnector<AppState, String?>(
                      converter: (store) => store.state.content['printBalance'],
                      builder: (context, printBalance) => Text(
                          printBalance ?? '',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.headline6)),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 5.0),
                    height: 30,
                    child: addMoneyButton(context))
              ])
            ]),
        StoreConnector<AppState, String?>(
            converter: (store) => store.state.content['printRefreshTime'],
            builder: (context, printRefreshTime) =>
                showLastRefreshedTime(printRefreshTime, context))
      ],
    );
  }

  Widget addMoneyButton(BuildContext context) {
    return ElevatedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: () => addMoneyDialog(context),
      child: const Center(child: Icon(Icons.add)),
    );
  }

  @override
  String getTitle() => 'Impressões';

  @override
  onClick(BuildContext context) {}
}
