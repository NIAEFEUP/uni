

import 'package:app_feup/view/Pages/GeneralPageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class UnnamedPageView extends GeneralPageView{
  @override
  getScaffold(BuildContext context, Widget body){
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context),
      body: this.refreshState(context, body),
    );
  }
}