import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../../view/Theme.dart';

import '../widgets/NavigationDrawer.dart';

class ProfilePageView extends StatelessWidget {

  ProfilePageView({Key key}) : super(key: key);

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
    return new ListView(
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
              image: NetworkImage(
                "https://dei.fe.up.pt/gig/wp-content/uploads/sites/4/2017/02/AAS_Jorn-1.jpg")
            )
          )
        ),
        Padding(padding: const EdgeInsets.all(8.0)),
        Text(
          "Nome Mais Um Nome Apelido Muito Grande Mesmo",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: greyTextColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w400
          )
        ),
        Padding(padding: const EdgeInsets.all(5.0)),
        Text(
          "up201601234@fe.up.pt",
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
      title: "Mestrado Integrado em Engenharia Informática e Computação", 
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
              child: Text("3",
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
              child: Text("A Frequentar",
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
              child: Text("2016/2017",
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
              child: Text("5,11€",
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
              child: Text("-499,50€",
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
              child: Text("2019-02-28",
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
      height: queryData.size.height / 18,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () => {print("logout")},
        color: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Terminar Sessão',
              style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
              textAlign: TextAlign.center
            ),
            Padding(padding: EdgeInsets.all(8.0)),
            Icon(IconData(0xe879, fontFamily: 'MaterialIcons'), color: Colors.white, size: 30),
          ],
        )
      ),
    );
  }

}