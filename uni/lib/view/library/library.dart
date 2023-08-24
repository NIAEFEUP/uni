import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/library/widgets/library_occupation_tab.dart';

class LibraryPageView extends StatefulWidget {
  final bool startOnOccupationTab;
  const LibraryPageView({this.startOnOccupationTab = false, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryPageViewState();
}

class LibraryPageViewState extends GeneralPageViewState<LibraryPageView> {
  late final List<Tab> tabs;

  LibraryPageViewState() {
    tabs = const <Tab>[
      Tab(text: 'Ocupação'),
      Tab(text: 'Gabinetes'),
    ];
  }

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<LibraryOccupationProvider>(
        builder: (context, libraryOccupationProvider) =>
            LibraryOccupationTab());
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<LibraryOccupationProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
