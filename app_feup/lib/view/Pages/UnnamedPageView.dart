

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GeneralPageView.dart';

abstract class UnnamedPageView extends GeneralPageViewState{
  @override
  getScaffold(BuildContext context, Widget body){
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context),
      body: this.refreshState(context, body),
    );
  }
}