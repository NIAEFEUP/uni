import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../../view/Theme.dart';

import '../widgets/NavigationDrawer.dart';

class ProfilePageView extends StatelessWidget {
  ProfilePageView(
    {Key key,
    @required this.name,
    @required this.email,
    @required this.course,
    @required this.currentYear,
    @required this.currentState,
    @required this.yearFirstRegistration,
    @required this.printBalance,
    @required this.feesBalance,
    @required this.nextFeeLimitData,
    @required this.profileImageLink,
    @required this.logout}) 
    : super(key: key);

  final String name;
  final String email;
  final String course;
  final String currentYear;
  final String currentState;
  final String yearFirstRegistration;
  final String printBalance;
  final String feesBalance;
  final String nextFeeLimitData;
  final String profileImageLink;
  final Function logout;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Perfil", textAlign: TextAlign.start)),
      drawer: new NavigationDrawer(),
      body: createScrollableProfileView(context)
    );
  }

  Widget createScrollableProfileView(BuildContext context){
    final MediaQueryData queryData = MediaQuery.of(context);
    return ListView(
      shrinkWrap: false,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        profileInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        courseInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        printsInfo(context),
        Padding(padding: const EdgeInsets.all(10.0)),
        accountInfo(context),
        Padding(padding: const EdgeInsets.all(15.0)),
        logOutButton(context, queryData)
      ]
    );
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
              image: NetworkImage(profileImageLink)
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

  Widget courseInfo (BuildContext context){
    return new GenericCard(
      title: course, 
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
              child: Text(currentYear,
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
              child: Text(currentState,
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
              child: Text(yearFirstRegistration,
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

  Widget logOutButton(BuildContext context, MediaQueryData queryData){
    return SizedBox(
      width: queryData.size.width / 2.5, // this doens't work
      height: queryData.size.height / 18,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () => {logout()},
        color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sair',
              style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
              textAlign: TextAlign.center
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Icon(IconData(0xe879, fontFamily: 'MaterialIcons'), color: Colors.white, size: 23),
          ],
        )
      ),
    );
  }
}