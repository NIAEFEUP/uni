import 'package:app_feup/controller/LifecycleEventHandler.dart';
import 'package:flutter/material.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';



class LifeCycleWidget extends StatefulWidget {
  LifeCycleWidget({
    Key key
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

class LifeCycle extends State<LifeCycleWidget>{
  WidgetsBindingObserver lifeCycleEventHandler;
  final Widget child;

  LifeCycle({
    Key key,
    this.child
  });


  @override
  void initState() {
    super.initState();
    StoreConnector<AppState, VoidCallback>(
      converter: (store){

        return () =>
            WidgetsBinding.instance.addObserver(this.lifeCycleEventHandler =  new LifecycleEventHandler(store: store));
      },
      builder: (context, observer){
        observer;
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this.lifeCycleEventHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this.child;
  }
}