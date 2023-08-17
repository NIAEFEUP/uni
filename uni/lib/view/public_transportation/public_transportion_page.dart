import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/public_transport_provider.dart';
import 'package:uni/view/common_widgets/last_update_timestamp.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';

class PublicTransportationPage extends StatefulWidget {
  const PublicTransportationPage({super.key});

  @override
  State<StatefulWidget> createState() => PublicTransportationPageState();
}

class PublicTransportationPageState
    extends GeneralPageViewState<PublicTransportationPage> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<PublicTransportationProvider>(
      builder: (context, publicTransportationProvider) {
        return ListView(
          children: [
            const PageTitle(name: 'Transportes Públicos'),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const LastUpdateTimeStamp<PublicTransportationProvider>(),
                    IconButton(
                        onPressed: () {
                          //TODO: make public transport add page
                        },
                        icon: const Icon(Icons.add),)
                  ],
                ),),
            //don't know if i'll remove it
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(),),
            buildCards(context, publicTransportationProvider)
          ],
        );
      },
    );
  }

  Widget buildCards(
      BuildContext context, PublicTransportationProvider provider,) {
    return Container();
  }

  
  @override
  Future<void> onRefresh(BuildContext context) async {
    await Provider.of<PublicTransportationProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
