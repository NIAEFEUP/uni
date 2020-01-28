import 'package:flutter/material.dart';
import 'GeneralPageView.dart';
import 'package:app_feup/view/Widgets/SecondaryPageBackButton.dart';

abstract class SecondaryPageView extends GeneralPageView{

  @override
  Widget build(BuildContext context) {
    return this.getScaffold(
        context,
        this.bodyWrapper(context)
    );
  }

  Widget bodyWrapper(BuildContext context){
    return new SecondaryPageBackButton(
        context: context,
        child: this.getBody(context)
    );
  }
}