

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'general_page_view.dart';


abstract class UnnamedPageView extends GeneralPageViewState{
  @override
  getScaffold(BuildContext context, Widget body){
    return  Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: buildAppBar(context),
      body: this.refreshState(context, body),
    );
  }
}