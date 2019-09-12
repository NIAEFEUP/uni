import 'package:app_feup/model/entities/Course.dart';
import 'package:app_feup/view/Pages/SecondaryPageView.dart';
import 'package:flutter/material.dart';
import '../Widgets/GenericCard.dart';
import '../../view/Theme.dart';

class ProfilePageView extends SecondaryPageView {
  ProfilePageView(
    {Key key,
    @required this.name,
    @required this.email,
    @required this.currentState,
    @required this.printBalance,
    @required this.printRefreshTime,
    @required this.feesBalance,
    @required this.nextFeeLimitData,
    @required this.feesRefreshTime,
    @required this.courses});

  final String name;
  final String email;
  final Map<String, String> currentState;
  final String printBalance;
  final String printRefreshTime;
  final String feesBalance;
  final String nextFeeLimitData;
  final String feesRefreshTime;
  final List<Course> courses;

  @override
  Widget getBody(BuildContext context) {
    return createScrollableProfileView(context);
  }

  Widget createScrollableProfileView(BuildContext context){
    return ListView(
      shrinkWrap: false,
      children: childrenList(context)
    );
  }

  @override
  Widget getTopRightButton(BuildContext context){
    return IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(
            Icons.close
          )
        );
  }

  List<Widget> childrenList(BuildContext context) {
    List<Widget> list = new List();
    list.add(Padding(padding: const EdgeInsets.all(10.0)));
    list.add(profileInfo(context));
    list.add(Padding(padding: const EdgeInsets.all(10.0)));
    for(var i = 0; i < courses.length; i++){
      list.add(courseInfo(context, courses[i], currentState == null ? "?" : currentState[courses[i].name]));
      list.add(Padding(padding: const EdgeInsets.all(10.0)));
    }
    list.add(printsInfo(context));
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
              child: getInfoText(course.currYear, context),
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
              margin: const EdgeInsets.only(top: 10.0, bottom: 8.0, right: 20.0),
              child: getInfoText(state, context),
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
              margin: const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 25.0),
              child: getInfoText(course.firstEnrollment.toString() + "/" + (course.firstEnrollment+1).toString(), context)
            )
          ]),
        ]
      )
    );
  }

  Text getInfoText(String text, BuildContext context) {
    return Text(text,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.display2
            );
  }

  Widget printsInfo (BuildContext context){
    return new GenericCard(
      title: "Impressões", 
      child:
        new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
              Table(
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
                      child: getInfoText(printBalance, context),
                    ),
                  ])
                ]
            ),
            showLastRefreshedTime(printRefreshTime, context)
          ],
        )
    );
  }

  Widget accountInfo (BuildContext context){
    return new GenericCard(
        title: "Conta Corrente",
        child: Column(children:[ Table(
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
                  child: getInfoText(feesBalance, context),
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
                  child: getInfoText(nextFeeLimitData, context),
                )
              ]),
            ]
        ),
        showLastRefreshedTime(feesRefreshTime, context)
        ]
      )
    );
  }

  showLastRefreshedTime(time, context) {
    var t = DateTime.parse(time);
    return Container(
        child: Text("última atualização às " +
            t.hour.toString() + ":" + t.minute.toString(),
            style: Theme
                .of(context)
                .textTheme
                .display3),
        alignment: Alignment.center
    );
  }
}