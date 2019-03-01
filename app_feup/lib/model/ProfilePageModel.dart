import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/ProfilePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();

  //Handle arguments from parent
  ProfilePage({Key key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  
  String name;
  String email;
  String course;
  String currentYear;
  String currentState;
  String yearFirstRegistration;
  String printBalance;
  String feesBalance;
  String nextFeeLimitData;

  @override
  void initState() {
    super.initState();
    name = "";
    email = "";
    course = "";
    currentYear = "";
    currentState = "";
    yearFirstRegistration = "";
    printBalance = "";
    feesBalance = "";
    nextFeeLimitData = "";
  }

  @override
  Widget build(BuildContext context) {
    updateInfo();
    return new ProfilePageView(
      name: name,
      email: email,
      course: course,
      currentYear: currentYear,
      currentState: currentState,
      yearFirstRegistration: yearFirstRegistration,
      printBalance: printBalance,
      feesBalance: feesBalance,
      nextFeeLimitData: nextFeeLimitData,
      profileImage: getProfileImage(),
      logout: () => _logout());
  }

  void updateInfo(){
    setState(() {
      name = "Nome Mais Um Nome Apelido Muito Grande Mesmo";
      email = "up201601234@fe.up.pt";
      course = "Mestrado Integrado em Engenharia Informática e Computação";
      currentYear = "3";
      currentState = "A Frequentar";
      yearFirstRegistration = "2016/2017";
      printBalance = "5,12€";
      feesBalance = "-499,50€";
      nextFeeLimitData = "2019-02-28";
    });
  }

  NetworkImage getProfileImage(){
    NetworkImage profileImage;

    String studentNo = StoreProvider.of<AppState>(context).state.content['session']['studentNumber'];
    String url = "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=" + studentNo;

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = StoreProvider.of<AppState>(context).state.content['session']['cookies'];

    profileImage = NetworkImage(url, headers: headers);

    return profileImage;
  }

  void _logout() {
    print("logout");
  }

}