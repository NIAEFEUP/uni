

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/public_transport_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

class PublicTransportationPage extends StatefulWidget{
  const PublicTransportationPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => PublicTransportationPageState();
}

class PublicTransportationPageState extends GeneralPageViewState<PublicTransportationPage>{

  @override
  Widget getBody(BuildContext context){
    return Consumer<PublicTransportationProvider>(
      builder: ((context, publicTransportationProvider, _) {
        return const PublicTransportViewer();
      }),
    );
  }
}

class PublicTransportViewer extends StatefulWidget{
  const PublicTransportViewer({super.key});

  @override
  State<StatefulWidget> createState() => PublicTransportViewerState();

}

class PublicTransportViewerState extends State<PublicTransportViewer>{
  @override
  Widget build(BuildContext context) {
    return const Text("Test");
  }

}