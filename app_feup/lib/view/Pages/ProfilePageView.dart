import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../../view/Theme.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/NavigationDrawer.dart';

class ProfilePageView extends StatelessWidget {
  ProfilePageView(
    {Key key,
    @required this.name,
    @required this.email,
    @required this.currentState,
    @required this.printBalance,
    @required this.feesBalance,
    @required this.nextFeeLimitData,
    @required this.courses,
    @required this.profileImage}) 
    : super(key: key);

  final String name;
  final String email;
  final Map<String, String> currentState;
  final String printBalance;
  final String feesBalance;
  final String nextFeeLimitData;
  final List<Course> courses;
  final CachedNetworkImageProvider profileImage;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Perfil", textAlign: TextAlign.start),
      ),
      drawer: new NavigationDrawer(),
      body: createScrollableProfileView(context)
    );
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
      list.add(courseInfo(context, courses[i], currentState[courses[i].name]));
      list.add(Padding(padding: const EdgeInsets.all(10.0)));
    }
    list.add(printsInfo(context));
    list.add(Padding(padding: const EdgeInsets.all(10.0)));
    list.add(accountInfo(context));
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
            image: DecorationImage(
              fit: BoxFit.cover,
              image: profileImage
            )
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

  Widget courseInfo (BuildContext context, Course course, String state){
    return new GenericCard(
      title: course.name, 
      child: Table(
        columnWidths: {1: FractionColumnWidth(.4)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Text("Ano curricular atual: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
              child: Text(course.currYear,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, left: 20.0),
              child: Text("Estado atual: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 30.0),
              child: Text(state,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 20.0),
              child: Text("Ano da primeira inscrição: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 30.0),
              child: Text(course.firstEnrollment.toString() + "/" + (course.firstEnrollment+1).toString(),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ]),
        ]
      )
    );
  }

  Widget printsInfo (BuildContext context){
    return new GenericCard(
      title: "Impressões", 
      child: Table(
        columnWidths: {1: FractionColumnWidth(.4)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Text("Valor disponível: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 30.0),
              child: Text(printBalance,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ])
        ]
      )
    );
  }

  Widget accountInfo (BuildContext context){
    return new GenericCard(
      title: "Conta Corrente", 
      child: Table(
        columnWidths: {1: FractionColumnWidth(.4)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, left: 20.0),
              child: Text("Saldo: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 8.0, right: 30.0),
              child: Text(feesBalance,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ]),
          TableRow(children: [
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 20.0, left: 20.0),
              child: Text("Data limite próxima prestação: ",
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w100
                )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 20.0, right: 30.0),
              child: Text(nextFeeLimitData,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: greyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
            )
          ])
        ]
      )
    );
  }
}