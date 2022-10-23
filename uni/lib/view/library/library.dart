import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/library/widgets/library_occupation_card.dart';

class LibraryPageView extends StatefulWidget {
  const LibraryPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPageView> {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, Tuple2<LibraryOccupation, RequestStatus>>(
        converter: (store) {
      final LibraryOccupation occupation =
          store.state.content['libraryOccupation'];
      return Tuple2(occupation, store.state.content['libraryOccupationStatus']);
    }, builder: (context, occupationInfo) {
      return RequestDependentWidgetBuilder(
          context: context,
          status: occupationInfo.item2,
          contentGenerator: generateOccupationPage,
          content: occupationInfo.item1,
          contentChecker: occupationInfo.item1.capacity != 0,
          onNullContent: Center(
              child: Text('Não existem dados para apresentar',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center)));
    });
  }

  Widget generateOccupationPage(occupation, context) {
    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          const PageTitle(name: 'Biblioteca'),
          LibraryOccupationCard(),
          const PageTitle(name: 'Pisos'),
          createFloorRow(occupation.getFloor(1), occupation.getFloor(2)),
          createFloorRow(occupation.getFloor(3), occupation.getFloor(4)),
          createFloorRow(occupation.getFloor(5), occupation.getFloor(6))
        ]);
  }

  Widget createFloorRow(FloorOccupation floor1, FloorOccupation floor2) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      createFloorCard(floor1),
      createFloorCard(floor2),
    ]);
  }

  Widget createFloorCard(FloorOccupation floor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 150.0,
      width: 150.0,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).cardColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(0x1c, 0, 0, 0),
              blurRadius: 7.0,
              offset: Offset(0.0, 1.0),
            )
          ]),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text('Piso ${floor.getNumber()}',
            style: Theme.of(context).textTheme.headline5),
        Text('${floor.getPercentage()}%',
            style: Theme.of(context).textTheme.headline6),
        Text('${floor.getOccupation()}/${floor.getCapacity()}',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Theme.of(context).colorScheme.background)),
        LinearPercentIndicator(
          lineHeight: 7.0,
          percent: floor.getPercentage() / 100,
          progressColor: Theme.of(context).colorScheme.secondary,
        )
      ]),
    );
  }
}
