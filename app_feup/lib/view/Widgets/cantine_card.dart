
import 'package:uni/model/app_state.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/utils/constants.dart' as Constants;
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'generic_card.dart';

class CantineCard extends GenericCard {
  CantineCard({Key key}) : super(key: key);

  @override
  String getTitle() => 'Cantinas';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navExams);

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<String, RequestStatus>> (
        converter: (store) => Tuple2('One', store.state.content['cantineStatus']),
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
      children: this.getCantineRows(context, cantines),
    );
  }

  List<Widget> getCantineRows(context, exams) {
    final List<Widget> rows = <Widget>[];
    return rows;
  }
}
