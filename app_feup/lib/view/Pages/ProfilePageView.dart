import 'package:app_feup/view/Pages/SecondaryPageView.dart';
import 'package:app_feup/view/Widgets/AccountInfoCard.dart';
import 'package:app_feup/view/Widgets/CourseInfoCard.dart';
import 'package:app_feup/view/Widgets/PrintInfoCard.dart';
import 'package:flutter/material.dart';
import '../Widgets/GenericCard.dart';
import '../../view/Theme.dart';
import 'package:app_feup/model/entities/Profile.dart';

class ProfilePageView extends SecondaryPageView {
  ProfilePageView(
    {Key key,
    @required this.name,
    @required this.email,
    @required this.currentState,
    @required this.printBalance,
    @required this.feesBalance,
    @required this.nextFeeLimitData,
    @required this.courses});

  final String name;
  final String email;
  final Map<String, String> currentState;
  final String printBalance;
  final String feesBalance;
  final String nextFeeLimitData;
  final List<Course> courses;

  @override
  Widget getBody(BuildContext context) {
    return createScrollableProfileView(context);
  }

  Widget createScrollableProfileView(BuildContext context){
    return ListView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(20.0),
      children: childrenList(context)
    );
  }

  List<Widget> childrenList(BuildContext context) {
    List<Widget> list = new List();
    list.add(profileInfo(context));
    list.add(Padding(padding: const EdgeInsets.all(10.0)));
    for(var i = 0; i < courses.length; i++){
      list.add(CourseInfoCard(course: courses[i], courseState: currentState[courses[i].name]));
      list.add(Padding(padding: const EdgeInsets.all(10.0)));
    }
    list.add(PrintInfoCard(printBalance: printBalance));
    list.add(Padding(padding: const EdgeInsets.all(10.0)));
    list.add(AccountInfoCard(feesBalance: feesBalance, nextFeeLimitData: nextFeeLimitData));
    return list;
  }
  Widget profileInfo (BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: buildDecorageImage(context)
          )
        ),
        Padding(padding: const EdgeInsets.all(8.0)),
         Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyTextColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w400
          )
        ),
        Padding(padding: const EdgeInsets.all(5.0)),
        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w200
          )
        ),
      ],
    );
  }
}