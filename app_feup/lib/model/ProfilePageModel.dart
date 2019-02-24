import 'package:app_feup/view/Pages/ProfilePageView.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();

  //Handle arguments from parent
  ProfilePage({Key key}) : super(key: key);
}

class _ProfilePageState extends State<ProfilePage> {
  
  String name = "";
  String email = "";
  String course = "";
  String currentYear = "";
  String currentState = "";
  String yearFirstRegistration = "";
  String printBalance = "";
  String feesBalance = "";
  String nextFeeLimitData = "";
  String profileImageLink = "";

  @override
  void initState() {
    super.initState();
    updateInfo();
  }

  @override
  Widget build(BuildContext context) {
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
      profileImageLink: profileImageLink,
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
      profileImageLink = "https://dei.fe.up.pt/gig/wp-content/uploads/sites/4/2017/02/AAS_Jorn-1.jpg";
    });
  }

  void _logout() {
    print("logout");
  }
}
